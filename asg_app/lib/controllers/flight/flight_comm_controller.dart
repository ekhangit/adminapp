import 'dart:async';
import 'dart:developer';

import 'package:asg_app/models/flight_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import '../../models/staff_model.dart';
import '../../services/flight_chat_service.dart';
import '../../services/flight_comm_service.dart';
import '../storage/data_storage_controller.dart';

class FlightCommController extends GetxController {
  RxString formattedDateTime = ''.obs;
  Timer? _timer;

  final Map<int, StreamSubscription> _flightChatSubscriptions = {};
  final _lastUnreadCounts = <int, int>{};

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  var myFlightList = <FlightsModel>[].obs;
  var allFlightList = <FlightsModel>[].obs;
  var arrivalFlightList = <FlightsModel>[].obs;
  var departureFlightList = <FlightsModel>[].obs;
  var cancelledFlightList = <FlightsModel>[].obs;

  var isFlightCommLoading = false.obs;
  var isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startDateTimeUpdater();
    _fetchData();
  }

  void _startDateTimeUpdater() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  // void _updateTime() {
  //   final now = DateTime.now().toUtc();
  //   final formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm:ss \'UTC\'');
  //   formattedDateTime.value = formatter.format(now);
  // }

  Future<void> navigateDate(int daysToAdd) async {
    final currentDate = selectedDate.value ?? DateTime.now().toUtc();
    final newDate = currentDate.add(Duration(days: daysToAdd));

    // Check if new date is within allowed range
    final now = DateTime.now().toUtc();
    final minDate = now.subtract(const Duration(days: 30));
    final maxDate = now.add(const Duration(days: 30));

    if (newDate.isBefore(minDate) || newDate.isAfter(maxDate)) {
      // Optionally show a snackbar or toast that date is out of range
      return;
    }

    await handleDateChange(newDate);
  }

  void _updateTime() {
    final now = DateTime.now().toUtc();
    final dateToShow = selectedDate.value ?? now;

    // Check if we're showing today (either no selection or explicitly selected today)
    final isToday =
        selectedDate.value == null ||
        (selectedDate.value != null &&
            DateUtils.isSameDay(selectedDate.value, now));

    if (isToday) {
      // Always use current time for today
      final formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm:ss \'UTC\'');
      formattedDateTime.value = formatter.format(now); // Use current time
    } else {
      // Show just date for other days
      final formatter = DateFormat('EEEE, dd MMMM yyyy');
      formattedDateTime.value = formatter.format(dateToShow);
    }

    // print('formattedDateTime: ${formattedDateTime.value}');
  }

  // Add this method to handle date changes from the UI
  Future<void> handleDateChange(DateTime? newDate) async {
    if (newDate == null) return;

    // Don't fetch if same date is selected again
    if (selectedDate.value != null &&
        DateUtils.isSameDay(selectedDate.value, newDate)) {
      return;
    }

    selectedDate.value = newDate;
    await fetchFlightComm();
    print('[FlightCommController] Date changed to: ${selectedDate.value}');
  }

  Future<void> _fetchData() async {
    await fetchFlightComm();
    fetchFlightStaff();
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

  Future<void> fetchFlightComm({bool isRefereshing = false}) async {
    // final now = DateTime.now().toUtc();

    final dateToFetch = selectedDate.value ?? DateTime.now().toUtc();
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateToFetch);

    log('[FlightCommController] formattedDate: $formattedDate');
    if (isRefereshing) {
      isRefreshing.value = true;
    } else {
      isFlightCommLoading.value = true;
    }

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

        final firebaseUser = FirebaseAuth.instance.currentUser;

        if (firebaseUser == null) {
          log(
            '[FlightCommController] User not authenticated. Skipping Firestore listener.',
          );
          return;
        }

        _setupFlightChatListeners();
      } else {
        log('[FlightCommController] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[FlightCommController] Exception: $e');
      log('[FlightCommController] Stack: $stack');
    } finally {
      if (isRefereshing) {
        isRefreshing.value = false;
      } else {
        isFlightCommLoading.value = false;
      }
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
    _timer?.cancel();
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

  void updateFlightUnreadCount(int flightId, int unreadCount) {
    // log(
    //   '[FlightCommController] Updating unread count for flight $flightId: $unreadCount',
    // );

    final lists = [
      allFlightList,
      arrivalFlightList,
      departureFlightList,
      cancelledFlightList,
      myFlightList,
    ];

    for (final list in lists) {
      final flight = list.firstWhereOrNull((f) => f.id == flightId);
      if (flight != null && flight.unReadCount.value != unreadCount) {
        flight.unReadCount.value = unreadCount;
      }
    }
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

    final flightRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(flightId.toString());

    _flightChatSubscriptions[flightId] = flightRef
        .collection('messages')
        .where('sender_id', isNotEqualTo: currentUserIdStr)
        .snapshots()
        .listen((snapshot) {
          final unreadCount = _calculateUnreadCount(snapshot, currentUserIdStr);

          if (unreadCount != _lastUnreadCounts[flightId]) {
            _lastUnreadCounts[flightId] = unreadCount;
            updateFlightUnreadCount(flightId, unreadCount);
          }
        }, onError: (e) => debugPrint('Flight $flightId listener error: $e'));
  }

  int _calculateUnreadCount(QuerySnapshot snapshot, String currentUserIdStr) {
    int count = 0;
    for (final doc in snapshot.docs) {
      final readBy = doc['read_by'] as List?;
      if (readBy == null || !readBy.contains(currentUserIdStr)) {
        count++;
      }
    }
    return count;
  }

  void _cleanupFlightChatListeners() {
    for (final sub in _flightChatSubscriptions.values) {
      sub.cancel();
    }
    _flightChatSubscriptions.clear();
    _lastUnreadCounts.clear();
  }
}
