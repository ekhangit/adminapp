import 'dart:async';
import 'dart:developer';

import 'package:aviation_app/models/flight_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import '../../models/staff_model.dart';
import '../../services/flight_chat_service.dart';
import '../../services/flight_comm_service.dart';
import '../storage/data_storage_controller.dart';

class FlightCommController extends GetxController {
  RxString formattedDateTime = ''.obs;
  late Timer _timer;

  final Map<int, StreamSubscription> _flightChatSubscriptions = {};

  var myFlightList = <FlightsModel>[].obs;
  var allFlightList = <FlightsModel>[].obs;
  var arrivalFlightList = <FlightsModel>[].obs;
  var departureFlightList = <FlightsModel>[].obs;
  var cancelledFlightList = <FlightsModel>[].obs;

  var isFlightCommLoading = false.obs;
  var isFlightCommLoading2 = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startDateTimeUpdater();
    fetchFlightComm();
    fetchFlightStaff();
    _setupFlightChatListeners();
  }

  void _startDateTimeUpdater() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now().toUtc();
    final formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm:ss \'UTC\'');
    formattedDateTime.value = formatter.format(now);
  }

  var selectedFilter = 'Departures'.obs;

  final List<String> filters = [
    'All',
    'Arrivals',
    'Departures',
    'Cancelled',
    'My Flights',
  ];

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  var selectedFlightIndex = (-1).obs;
  var favoriteFlights = <int>[].obs;

  void selectFlight(int index) {
    if (selectedFlightIndex.value == index) {
      selectedFlightIndex.value = -1; // Unselect if already selected
    } else {
      selectedFlightIndex.value = index;
    }
  }

  Future<void> fetchFlightComm() async {
    final now = DateTime.now().toUtc();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    log('[FlightCommController] formattedDate: $formattedDate');
    isFlightCommLoading.value = true;

    try {
      final response = await FlightCommService.instance.allFlightComm(
        date: formattedDate,
      );

      if (response.isSuccess && response.data != null) {
        final map = response.data!;
        allFlightList.assignAll(map['all_flights'] ?? []);
        arrivalFlightList.assignAll(map['arrival_flights'] ?? []);
        departureFlightList.assignAll(map['departure_flights'] ?? []);
        cancelledFlightList.assignAll(map['cancelled_flights'] ?? []);
        myFlightList.assignAll(map['my_flights'] ?? []);

        // show complete list of flights with json
        // log('[FlightCommController]: ${arrivalFlightList.map((f) => f.id)}');

        _setupFlightChatListeners();
      } else {
        log('[FlightCommController] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[FlightCommController] Exception: $e');
      log('[FlightCommController] Stack: $stack');
    } finally {
      isFlightCommLoading.value = false;
    }
  }

  List<FlightsModel> get flightList {
    switch (selectedFilter.value.toLowerCase()) {
      case 'all':
        return allFlightList;
      case 'arrivals':
        return arrivalFlightList;
      case 'departures':
        return departureFlightList;
      case 'cancelled':
        return cancelledFlightList;
      case 'my flights':
        return myFlightList;
      default:
        return allFlightList;
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    _cleanupFlightChatListeners();
    super.onClose();
  }

  Future<void> toggleFlightFavorite(int index) async {
    final flight = flightList[index];
    final wasFavorite = flight.isFavorite.value;

    // Optimistically toggle UI
    flight.isFavorite.toggle();

    final success = await addToFavourite(flight.id);

    if (!success) {
      flight.isFavorite.value = wasFavorite; // Revert if failed
      return;
    }

    final isNowFavorite = flight.isFavorite.value;

    // 🟢 Add to My Flights
    if (isNowFavorite) {
      if (!myFlightList.any((f) => f.id == flight.id)) {
        myFlightList.add(flight);
      }
    }
    // 🔴 Remove from My Flights
    else {
      myFlightList.removeWhere((f) => f.id == flight.id);
    }
  }

  Future<bool> addToFavourite(int flightId) async {
    log("[addToFavourite] flightId: $flightId");

    try {
      final response = await FlightCommService.instance.flightAddToFavourite(
        flightId: flightId,
      );

      if (response.isSuccess) {
        log("[addToFavourite] Flight added to favorites successfully.");
        return true;
      } else {
        log("[addToFavourite] API Error: ${response.errorMessage}");
        return false;
      }
    } catch (e, stack) {
      log("[addToFavourite] Exception: $e");
      log("[addToFavourite] Stack: $stack");
      return false;
    }
  }

  // All Flight Staffs

  final RxList<StaffModel> flightStaff = <StaffModel>[].obs;

  Future<void> fetchFlightStaff() async {
    try {
      final response = await FlightChatService.instance.flightStaff();

      if (response.isSuccess && response.data != null) {
        flightStaff.assignAll(response.data!);
        log('[fetchFlightStaff] Flight staff fetched successfully.');
      } else {
        log('[fetchFlightStaff] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[fetchFlightStaff] Exception: $e');
      log('[fetchFlightStaff] Stack: $stack');
    }
  }

  // In FlightCommController
  void updateFlightUnreadCount(int flightId, int unreadCount) {
    log(
      '[updateFlightUnreadCount] unread count for flight $flightId to $unreadCount',
    );

    final listsToUpdate = [
      allFlightList,
      arrivalFlightList,
      departureFlightList,
      cancelledFlightList,
      myFlightList,
    ];

    for (final list in listsToUpdate) {
      try {
        final flight = list.firstWhereOrNull((f) => f.id == flightId);
        if (flight != null && flight.unReadCount.value != unreadCount) {
          flight.unReadCount.value = unreadCount;
        }
        // log('Updated unread count for flight $flightId in ${list.runtimeType}');
      } catch (e) {
        log('Error updating unread count in ${list.runtimeType}: $e');
      }
    }

    update();
  }

  void _setupFlightChatListeners() {
    _cleanupFlightChatListeners();

    // Setup listeners for all current flights
    for (final flight in allFlightList) {
      _setupFlightChatListener(flight.id);
    }
  }

  void _setupFlightChatListener(int flightId) {
    if (_flightChatSubscriptions.containsKey(flightId)) {
      log('[FlightCommController] Already listening to flight $flightId');
    }

    final currentUserId = DataStorageController.to.user.id;
    final currentUserIdStr = currentUserId.toString();

    _flightChatSubscriptions[flightId] = FirebaseFirestore.instance
        .collection('chats')
        .doc(flightId.toString())
        .collection('messages')
        .where('sender_id', isNotEqualTo: currentUserIdStr)
        .snapshots()
        .listen(
          (snapshot) {
            try {
              int unreadCount = 0;

              for (final doc in snapshot.docs) {
                final data = doc.data();

                // Safe handling of read_by field
                final readBy = _parseReadByList(data['read_by']);

                if (!readBy.contains(currentUserId)) {
                  unreadCount++;
                }
              }

              log(
                '[FlightCommController] Unread messages for flight $flightId: $unreadCount',
              );
              updateFlightUnreadCount(flightId, unreadCount);
            } catch (e, stack) {
              log('Error processing messages for flight $flightId: $e\n$stack');
            }
          },
          onError: (error) {
            log('Error listening to messages for flight $flightId: $error');
          },
        );
  }

  // Helper method to safely parse read_by list
  List<int> _parseReadByList(dynamic readByData) {
    if (readByData == null) return [];

    try {
      if (readByData is List) {
        // return readByData.map((e) => e.toString()).toList();
        return readByData.map((item) {
          if (item is String) {
            return int.tryParse(item) ?? 0; // Convert string to int
          } else if (item is int) {
            return item; // Already an int
          } else if (item is double) {
            return item.toInt(); // Convert double to int
          }
          return 0; // Default fallback
        }).toList();
      }
      return [];
    } catch (e) {
      log('Error parsing read_by list: $e');
      return [];
    }
  }

  void _cleanupFlightChatListeners() {
    _flightChatSubscriptions.values.forEach((sub) => sub.cancel());
    _flightChatSubscriptions.clear();
  }
}
