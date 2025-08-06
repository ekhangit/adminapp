import 'dart:async';
import 'dart:developer';

import 'package:dhs_app/controllers/flight/flight_comm_controller.dart';
import 'package:dhs_app/controllers/flight/flight_info_controller.dart';
import 'package:dhs_app/services/flight_chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import '../../models/chat_model.dart';
import 'package:intl/intl.dart';

import '../../models/flight_detail_model.dart';
import '../../models/staff_model.dart';
import '../storage/data_storage_controller.dart';

class ChatController extends GetxController {
  var argument = Get.arguments;

  final ScrollController scrollController = ScrollController();

  // Pagination
  final int _pageSize = 50;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isInitialLoad = true;
  bool _isLoadingMessages = false;

  var staffList = <StaffModel>[].obs;

  StreamSubscription<QuerySnapshot>? _messagesSubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
    _setupFirestoreListener();
  }

  void _initializeChat() {
    fetchFlightChatDetail(argument);
    _setupFlightDetailListener();
    _setupStaffList();
    _loadInitialMessages();
  }

  void _setupFirestoreListener() {
    _messagesSubscription?.cancel();

    _messagesSubscription = FirebaseFirestore.instance
        .collection('chats')
        .doc(argument.toString())
        .collection('messages')
        .orderBy('created_at', descending: false)
        .snapshots()
        .listen((snapshot) {
          print('[ChatController] New messages snapshot received');

          _handleNewMessages(snapshot);
        });
  }

  // FIXED: Handle new messages properly
  void _handleNewMessages(QuerySnapshot snapshot) async {
    // Process document changes instead of all docs
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        final newMessage = await _parseMessage(change.doc);

        // 1. Skip messages sent by current user (already handled optimistically)
        if (newMessage.senderId == DataStorageController.to.user.id) {
          continue;
        }

        // Check if we already have this message (optimistic or real)
        final existingIndex = messages.indexWhere(
          (msg) =>
              msg.id == newMessage.id ||
              (msg.id.startsWith('optimistic-') && msg.time == newMessage.time),
        );

        if (existingIndex != -1) {
          // Replace optimistic message with real one
          messages[existingIndex] = newMessage;
        } else {
          // Add new message
          messages.add(newMessage);
        }

        // Immediately mark as read if it's not from current user
        if (newMessage.senderId != DataStorageController.to.user.id) {
          markSingleMessageRead(newMessage);
        }
      }
    }

    // Scroll to bottom and update read status
    _scrollToBottom();
    markVisibleMessagesAsRead();
  }

  void _setupFlightDetailListener() {
    ever(flightDetail, (FlightDetailModel? detail) {
      if (detail != null) checkTabMessages();
    });
  }

  void _setupStaffList() {
    if (Get.isRegistered<FlightCommController>()) {
      final flightCommController = Get.find<FlightCommController>();
      staffList.assignAll(flightCommController.flightStaff);
    }
  }

  Future<void> _loadInitialMessages() async {
    await _loadMessages();
    _isInitialLoad = true;
  }

  Future<void> _loadMessages({bool loadMore = false}) async {
    if (_isLoadingMessages) return;
    if (!loadMore) {
      _lastDocument = null;
      _hasMore = true;

      if (messages.isNotEmpty) messages.clear();
    }

    if (!_hasMore) return;

    Query query = FirebaseFirestore.instance
        .collection('chats')
        .doc(argument.toString())
        .collection('messages')
        .orderBy('created_at', descending: false)
        .limit(_pageSize);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    try {
      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        _hasMore = false;
        return;
      }

      _lastDocument = snapshot.docs.last;
      final newMessages = await _parseMessages(snapshot.docs);

      // Log message types breakdown
      _logMessageTypes(newMessages);

      if (loadMore) {
        messages.insertAll(0, newMessages);
      } else {
        messages.assignAll(newMessages);
        _scrollToBottom();
        markVisibleMessagesAsRead();
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
    } finally {
      _isLoadingMessages = false;
    }
  }

  void _logMessageTypes(List<ChatMessage> messages) {
    log('📊 Logging message types breakdown...');

    // final typeCounts = <String, int>{};
    // var hasAttachmentCount = 0;

    for (final message in messages) {
      // Count message types
      final type = message.type ?? 'simple';
      // typeCounts[type] = (typeCounts[type] ?? 0) + 1;
      log('Message Type: $type');

      if (type == 'ckin') {
        log('CKIN Message: ${message.message.toString()}');
      }
    }
  }

  Future<List<ChatMessage>> _parseMessages(List<DocumentSnapshot> docs) async {
    return await Future.wait(docs.map((doc) => _parseMessage(doc)));
  }

  Future<ChatMessage> _parseMessage(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final senderIdStr = data['sender_id'].toString();

    final matchedStaff = staffList.firstWhereOrNull(
      (staff) => staff.id.toString() == senderIdStr,
    );

    // Get the timestamp and convert to ISO string
    final timestamp = data['created_at'] as Timestamp?;
    final isoTime = timestamp?.toDate().toUtc().toIso8601String() ?? '';

    return ChatMessage.fromJson({
      ...data,
      'sender_name': matchedStaff?.displayName ?? 'User',
      'station': matchedStaff?.airport.iataCode ?? 'Unknown',
      'created_at': isoTime, // Use consistent UTC ISO format
      'sender_id': senderIdStr,
    });
  }

  void _scrollToBottom() {
    if (scrollController.hasClients && !_isInitialLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
    _isInitialLoad = false;
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isSendingMessage.value) return;

    isSendingMessage.value = true;
    try {
      final currentUser = DataStorageController.to.user;
      final currentUserIdStr = currentUser.id.toString();

      final matchedStaff = staffList.firstWhereOrNull(
        (staff) => staff.id.toString() == currentUserIdStr,
      );

      // Create optimistic message
      final optimisticMessage = ChatMessage(
        id: 'optimistic-${DateTime.now().millisecondsSinceEpoch}',
        senderId: currentUser.id,
        senderName: matchedStaff?.displayName ?? 'User',
        station: matchedStaff?.airport.iataCode ?? 'Unknown',
        message: text,
        time: DateTime.now().toUtc().toIso8601String(),
        isOwn: true,
        readBy: [currentUser.id],
        type: 'simple',
      );

      // Add optimistically to UI
      messages.add(optimisticMessage);
      _scrollToBottom();

      final docRef = await FirebaseFirestore.instance
          .collection('chats')
          .doc(argument.toString())
          .collection('messages')
          .add({
            'sender_id': currentUserIdStr,
            'message': text,
            'message_type': 'simple',
            'read_by': [currentUserIdStr],
            'created_at': FieldValue.serverTimestamp(),
          });

      // Update local message with actual ID
      final index = messages.indexOf(optimisticMessage);
      if (index != -1) {
        messages[index] = messages[index].copyWith(id: docRef.id);
      }

      messageController.clear();
    } catch (e) {
      messages.removeWhere((msg) => msg.id.startsWith('optimistic-'));
      debugPrint('Error sending message: $e');
    } finally {
      isSendingMessage.value = false;
    }
  }

  Future<void> markVisibleMessagesAsRead() async {
    // log('[ChatController] markVisibleMessagesAsRead called');

    final currentUserId = DataStorageController.to.user.id;
    final currentUserIdStr = currentUserId.toString();

    // Get messages that haven't been read by the current user
    final unreadMessages =
        messages
            .where((msg) => !(msg.readBy?.contains(currentUserId) ?? true))
            .toList();

    // log(
    //   '[ChatController] markVisibleMessagesAsRead Unread messages count: ${unreadMessages.length}',
    // );

    if (unreadMessages.isEmpty) return;

    try {
      // Create a batch update
      final batch = FirebaseFirestore.instance.batch();
      int batchCount = 0;

      for (final message in unreadMessages) {
        if (batchCount >= 400) break; // Firestore batch limit

        log(
          '[ChatController] Marking message as read: ${message.id} | '
          'Sender: ${message.senderId} | Time: ${message.time}',
        );

        // Get the exact timestamp from the message
        final messageTime = DateTime.parse(message.time);
        final timestamp = Timestamp.fromDate(messageTime);

        // Find the message document by its unique properties
        Query query = FirebaseFirestore.instance
            .collection('chats')
            .doc(argument.toString())
            .collection('messages')
            .where('created_at', isEqualTo: timestamp)
            .where('sender_id', isEqualTo: message.senderId.toString())
            .limit(1);

        log(
          '[ChatController] markVisibleMessagesAsRead Querying for message: $query',
        );

        final snapshot = await query.get();
        log(
          '[ChatController] markVisibleMessagesAsRead Query result: ${snapshot.docs.length} docs found',
        );
        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs.first;
          batch.update(doc.reference, {
            'read_by': FieldValue.arrayUnion([currentUserIdStr]),
          });
          batchCount++;

          log('[ChatController]  Message marked as read: ${message.readBy}');

          // Update local message state
          if (message.readBy == null) {
            message.readBy = [currentUserId];
          } else {
            message.readBy!.add(currentUserId);
          }
        }
      }

      if (batchCount > 0) {
        await batch.commit();
        log('Marked $batchCount messages as read');

        // Update unread count in FlightCommController
        final newUnreadCount = _calculateUnreadCount();

        log(
          '[chatController] markVisibleMessagesAsRead Unread messages count: $newUnreadCount',
        );

        if (Get.isRegistered<FlightCommController>()) {
          Get.find<FlightCommController>().updateFlightUnreadCount(
            argument,
            newUnreadCount,
          );
        }
      }
    } catch (e, stack) {
      log('Error marking messages as read: $e');
      log('Stack trace: $stack');
    }
  }

  int _calculateUnreadCount() {
    final currentUserId = DataStorageController.to.user.id;
    return messages
        .where((msg) => !(msg.readBy?.contains(currentUserId) ?? true))
        .length;
  }

  Future<void> loadMoreMessages() async {
    if (!_hasMore) return;
    await _loadMessages(loadMore: true);
  }

  Future<void> markSingleMessageRead(ChatMessage message) async {
    final currentUserId = DataStorageController.to.user.id;
    if (message.readBy?.contains(currentUserId) ?? false) return;

    try {
      final currentUserIdStr = currentUserId.toString();
      final messageTime = DateTime.parse(message.time);
      final timestamp = Timestamp.fromDate(messageTime);

      // Find the message document
      Query query = FirebaseFirestore.instance
          .collection('chats')
          .doc(argument.toString())
          .collection('messages')
          .where('created_at', isEqualTo: timestamp)
          .where('sender_id', isEqualTo: message.senderId.toString())
          // .where('message', isEqualTo: message.message)
          .limit(1);

      final snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        await doc.reference.update({
          'read_by': FieldValue.arrayUnion([currentUserIdStr]),
        });

        // Update local message state
        if (message.readBy == null) {
          message.readBy = [currentUserId];
        } else {
          message.readBy!.add(currentUserId);
        }

        // Update unread count
        final newUnreadCount = _calculateUnreadCount();
        if (Get.isRegistered<FlightCommController>()) {
          Get.find<FlightCommController>().updateFlightUnreadCount(
            argument,
            newUnreadCount,
          );
        }
      }
    } catch (e) {
      debugPrint('Error marking single message read: $e');
    }
  }

  @override
  void onClose() {
    _messagesSubscription?.cancel();
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }

  // Add these variables
  final Map<String, bool> _tabHasMessages =
      {'MVT': false, 'LDM': false, 'PSM': false, 'PTM': false}.obs;

  // Method to check initial messages
  void checkTabMessages() {
    if (flightDetail.value == null) return;

    final messages = flightDetail.value!.messages;

    _tabHasMessages['MVT'] =
        messages.mvtArrival.isNotEmpty || messages.mvtDeparture.isNotEmpty;
    _tabHasMessages['LDM'] = messages.ldm.isNotEmpty;
    _tabHasMessages['LIR'] = messages.lir.isNotEmpty;
    _tabHasMessages['LDS'] = messages.lds.isNotEmpty;
    _tabHasMessages['PSM'] = messages.psm.isNotEmpty;
    _tabHasMessages['PTM'] = messages.ptm.isNotEmpty;
    _tabHasMessages['CPM'] = messages.cpm.isNotEmpty;

    log(
      'Message status - MVT: ${_tabHasMessages['MVT']}, '
      'LDM: ${_tabHasMessages['LDM']}, '
      'LIR: ${_tabHasMessages['LIR']}, '
      'LDS: ${_tabHasMessages['LDS']}, '
      'PSM: ${_tabHasMessages['PSM']}, '
      'PTM: ${_tabHasMessages['PTM']}, '
      'CPM: ${_tabHasMessages['CPM']}, ',
    );
  }

  bool hasMessages(String tabName) {
    return _tabHasMessages[tabName] ?? false;
  }

  final selectedTab = 'Chat'.obs;

  final List<Color> _avatarColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.cyan,
    Colors.pink,
  ];

  Color getAvatarColor(String name) {
    final hash = name.hashCode;
    final index = hash % _avatarColors.length;
    return _avatarColors[index];
  }

  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  TextEditingController messageController = TextEditingController();

  var flightDetailLoading = false.obs;

  Rxn<FlightDetailModel> flightDetail = Rxn<FlightDetailModel>();

  Future<void> fetchFlightChatDetail(int flightId) async {
    log('[fetchFlightChatDetail] flightId : $flightId');

    flightDetailLoading.value = true;

    try {
      final response = await FlightChatService.instance.flightChatDetail(
        flightId: flightId,
      );

      if (response.isSuccess && response.data != null) {
        // log('[fetchFlightChatDetail] Flight detail fetched successfully.');
        flightDetail.value = response.data!;
      } else {
        log('[fetchFlightChatDetail] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[fetchFlightChatDetail] Exception: $e');
      log('[fetchFlightChatDetail] Stack: $stack');
    } finally {
      flightDetailLoading.value = false;
    }
  }

  var isHeaderExpanded = false.obs;

  void toggleHeaderExpansion() {
    isHeaderExpanded.value = !isHeaderExpanded.value;
  }

  final RxBool isSendingMessage = false.obs;

  // CHAT FORM

  // Future<void> fetchFlightChats(int flightId) async {
  //   log('[ChatController] flightId : $flightId');

  //   try {
  //     final response = await FlightChatService.instance.flightChats(
  //       flightId: flightId,
  //     );

  //     if (response.isSuccess && response.data != null) {
  //       log('[ChatController] Flight chats fetched successfully.');
  //       messages.assignAll(response.data!);
  //     } else {
  //       log('[ChatController] API Error: ${response.errorMessage}');
  //     }
  //   } catch (e, stack) {
  //     log('[ChatController] Exception: $e');
  //     log('[ChatController] Stack: $stack');
  //   }
  // }

  // UPATE INFO

  final RxInt selectedIndex = 0.obs;
  final List<String> tabTitles = [
    "TRC",
    "CHECK IN",
    "SSR",
    "ARR",
    "PTS",
    "DSR",
    "FHR",
    "STAFF",
    "OCC",
  ];

  final RxList<String> selectedPos = <String>[].obs;
  final RxList<String> selectedLR = <String>[].obs;
  final RxList<String> selectedULD = <String>[].obs;
  final RxList<String> selectedVR = <String>[].obs;

  final List<String> posOptions = ["11", "12", "13", "14"];

  // ARR FORM
  final TextEditingController lofoController = TextEditingController();
  final TextEditingController lofoRemarksController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController mhbAHLController = TextEditingController();
  final TextEditingController ohdController = TextEditingController();
  final TextEditingController dprController = TextEditingController();

  Future<void> pickTime(bool isStart) async {
    final fixedTime = DateTime.utc(0, 1, 1, 12, 0);
    final formatted = DateFormat.Hm().format(fixedTime);

    if (isStart) {
      startTimeController.text = formatted;
    } else {
      endTimeController.text = formatted;
    }
  }

  void incrementTime(TextEditingController controller, {bool isHour = true}) {
    final now = TimeOfDay.now();
    final parts = controller.text.split(":");

    int hour = int.tryParse(parts[0]) ?? now.hour;
    int minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? now.minute;

    if (isHour) {
      hour = (hour + 1) % 24;
    } else {
      minute = (minute + 5) % 60;
    }

    controller.text =
        "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  void decrementTime(TextEditingController controller, {bool isHour = true}) {
    final now = TimeOfDay.now();
    final parts = controller.text.split(":");

    int hour = int.tryParse(parts[0]) ?? now.hour;
    int minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? now.minute;

    if (isHour) {
      hour = (hour - 1 + 24) % 24;
    } else {
      minute = (minute - 5 + 60) % 60;
    }

    controller.text =
        "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  Future<void> sendArr() async {
    log("[ChatController] Sending ARR data...");

    final payload = {
      "lofo": lofoController.text,
      "lofo_rmks": lofoRemarksController.text,
      "start_time": startTimeController.text,
      "end_time": endTimeController.text,
      "mhb_ahl": mhbAHLController.text,
      "ohd": ohdController.text,
      "dpr": dprController.text,
      "flight_id": argument, // make sure this is correctly set
    };

    log("[ChatController] ARR Payload: $payload");

    try {
      final response = await FlightChatService.instance.sendArr(payload);

      if (response.isSuccess) {
        log("[ChatController] ARR data submitted successfully.");
      } else {
        log("[ChatController] ARR submission failed: ${response.errorMessage}");
      }
    } catch (e, stack) {
      log("[ChatController] Exception while sending ARR: $e");
      log("[ChatController] Stack: $stack");
    }
  }

  // FHR FORM
  final missedArtg5ExplanationController = TextEditingController();
  final delayExplanationController = TextEditingController();
  final chkInTKGIssueController = TextEditingController();
  final rampCrewDistruptivePaxController = TextEditingController();
  final safetySecuritySystemController = TextEditingController();
  final otherController = TextEditingController();
  final involDeniedBoardingController = TextEditingController();

  Future<void> sendFhr() async {
    log("[ChatController] Sending FHR data...");

    final payload = {
      "MISSED_ARTSG_5_EXPLANATION": missedArtg5ExplanationController.text,
      "DELAY_EXPLANATION": delayExplanationController.text,
      "CHECK-IN/TKTG ISSUES": chkInTKGIssueController.text,
      "RAMP/CREWDISRUPTIVE PAX ETC": rampCrewDistruptivePaxController.text,
      "SAFETY/SECURITY/SYSTEM": safetySecuritySystemController.text,
      "OTHER": otherController.text,
      "INVOL DENIED BOARDING": involDeniedBoardingController.text,
    };

    log("[ChatController] FHR Payload: $payload");

    try {
      final response = await FlightChatService.instance.sendFhr(payload);

      if (response.isSuccess) {
        log("[ChatController] FHR data submitted successfully.");
      } else {
        log("[ChatController] FHR submission failed: ${response.errorMessage}");
      }
    } catch (e, stack) {
      log("[ChatController] Exception while sending ARR: $e");
      log("[ChatController] Stack: $stack");
    }
  }

  // Save Changes

  final RxBool saveLoading = false.obs;

  Future<void> saveChanges() async {
    log("[ChatController] Saving changes...");
    saveLoading.value = true;

    final selectedTabTitle = tabTitles[selectedIndex.value];

    final flightInfoController = Get.find<FlightInfoController>();

    try {
      switch (selectedTabTitle) {
        case "SSR":
          await flightInfoController.sendSsr();
          break;

        case "ARR":
          await sendArr();
          break;

        case "PTS":
          await flightInfoController.sendPts();
          break;

        case "DSR":
          await flightInfoController.sendDsr();
          break;

        case "FHR":
          await sendFhr();
          break;

        case "OCC":
          await flightInfoController.sendOcc();
          break;

        default:
          log(
            "[ChatController] No save handler defined for tab: $selectedTabTitle",
          );
      }

      log("[ChatController] Changes saved for tab: $selectedTabTitle");
    } catch (e, stack) {
      log("[ChatController] Save exception: $e");
      log("[ChatController] Stack: $stack");
    } finally {
      saveLoading.value = false;
    }
  }
}
