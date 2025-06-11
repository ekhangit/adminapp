import 'dart:async';
import 'dart:developer';

import 'package:aviation_app/controllers/flight/flight_info_controller.dart';
import 'package:aviation_app/services/flight_chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_model.dart';
import 'package:intl/intl.dart';

import '../../models/flight_detail_model.dart';
import '../storage/data_storage_controller.dart';

class ChatController extends GetxController {
  var argument = Get.arguments;

  final ScrollController scrollController = ScrollController();
  StreamSubscription<QuerySnapshot>? _messagesSubscription;

  @override
  void onInit() {
    super.onInit();

    log('[ChatController] argument : $argument');

    fetchFlightChatDetail(argument);
    // fetchFlightChats(argument);
    fetchFlightChatsWithFirebase(argument);

    // Scroll to bottom when messages change
    ever(messages, (_) {
      log("[ChatController] Messages updated, scrolling to bottom");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          log(
            "[ChatController] Scrolling to ${scrollController.position.maxScrollExtent}",
          );
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          log("[ChatController] ScrollController has no clients");
        }
      });
    });
  }

  @override
  void onClose() {
    _messagesSubscription?.cancel();
    scrollController.dispose(); // Dispose ScrollController
    super.onClose();
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
        flightDetail.value = response.data!;
        // log('[fetchFlightChatDetail] Flight detail fetched successfully.');
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

  // Future<void> sendMessage() async {
  //   log("[sendMessage] sendMessage data...");

  //   final text = messageController.text.trim();
  //   if (text.isEmpty) return;

  //   isSendingMessage.value = true;

  //   final payload = {
  //     "flight_id": argument,
  //     "message": text,
  //     "type": null,
  //     "file": null,
  //   };

  //   log("[sendMessage] sendMessage Payload: $payload");

  //   try {
  //     final response = await FlightChatService.instance.sendMessage(payload);

  //     if (response.isSuccess) {
  //       log("[ChatController] sendMessage data submitted successfully.");

  //       messageController.clear();
  //       // fetchFlightChats(argument);
  //     } else {
  //       log(
  //         "[ChatController] sendMessage submission failed: ${response.errorMessage}",
  //       );
  //     }
  //   } catch (e, stack) {
  //     log("[sendMessage] Exception while sending ARR: $e");
  //     log("[sendMessage] Stack: $stack");
  //   } finally {
  //     isSendingMessage.value = false;
  //   }
  // }

  Future<void> sendMessage() async {
    log("[sendMessage] sendMessage data...");

    final text = messageController.text.trim();
    if (text.isEmpty) return;

    isSendingMessage.value = true;

    try {
      final currentUser = DataStorageController.to.user;
      final message = ChatMessage(
        flightId: argument,
        senderId: currentUser.id,
        senderName: currentUser.name,
        station: 'Munich',
        message: text,
        attachment: null,
        fileName: null,
        type: null,
        messageFrom: null,
        chatMetadata: null,
        time: DateTime.now().toIso8601String(),
        isOwn: true,
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(argument.toString())
          .collection('messages')
          .add({
            'flight_id': message.flightId,
            'sender_id': message.senderId,
            'sender_name': message.senderName,
            'station': message.station,
            'message': message.message,
            'attachment': message.attachment,
            'file_name': message.fileName,
            'type': message.type,
            'message_from': message.messageFrom,
            'chat_metadata': message.chatMetadata,
            'created_at': FieldValue.serverTimestamp(),
          });

      log("[sendMessage] Message sent successfully.");
      messageController.clear();
    } catch (e, stack) {
      log("[sendMessage] Exception while sending message: $e");
      log("[sendMessage] Stack: $stack");
    } finally {
      isSendingMessage.value = false;
    }
  }

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

  Future<void> fetchFlightChatsWithFirebase(int flightId) async {
    log('[fetchFlightChatsWithFirebase] flightId : $flightId');

    try {
      _messagesSubscription?.cancel(); // Cancel any existing subscription

      _messagesSubscription = FirebaseFirestore.instance
          .collection('chats')
          .doc(flightId.toString())
          .collection('messages')
          .orderBy('created_at', descending: false)
          .snapshots()
          .listen(
            (snapshot) {
              final fetchedMessages =
                  snapshot.docs.map((doc) {
                    log(
                      '[fetchFlightChatsWithFirebase] Document ID: ${doc.id}',
                    );
                    final data = doc.data();

                    log('[fetchFlightChatsWithFirebase] Data: $data');

                    return ChatMessage.fromJson({
                      ...data,
                      'created_at':
                          (data['created_at'] as Timestamp?)
                              ?.toDate()
                              .toIso8601String() ??
                          '',
                    });
                  }).toList();

              messages.assignAll(fetchedMessages);
              log(
                '[fetchFlightChatsWithFirebase] Flight chats fetched successfully: ${messages.length} messages',
              );
            },
            onError: (e, stack) {
              log('[fetchFlightChatsWithFirebase] Firestore stream error: $e');
              log('[fetchFlightChatsWithFirebase] Stack: $stack');
            },
          );
    } catch (e, stack) {
      log('[fetchFlightChatsWithFirebase] Exception: $e');
      log('[fetchFlightChatsWithFirebase] Stack: $stack');
    }
  }

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
      // final response = await FlightChatService.instance.sendArr(payload);

      // if (response.isSuccess) {
      //   log("[ChatController] ARR data submitted successfully.");
      // } else {
      //   log("[ChatController] ARR submission failed: ${response.errorMessage}");
      // }
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
      // final response = await FlightChatService.instance.sendFhr(payload);

      // if (response.isSuccess) {
      //   log("[ChatController] FHR data submitted successfully.");
      // } else {
      //   log("[ChatController] FHR submission failed: ${response.errorMessage}");
      // }
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
