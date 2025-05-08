import 'dart:async';

import 'package:get/get.dart';

import 'package:intl/intl.dart';

class FlightCommController extends GetxController {
  RxString formattedDateTime = ''.obs;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _startDateTimeUpdater();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
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

  var selectedFilter = 'My Flights'.obs;

  final List<String> filters = [
    'My Flights',
    'Arrivals',
    'Departures',
    'All',
    'Canceled',
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

  void toggleFavorite(int index) {
    if (favoriteFlights.contains(index)) {
      favoriteFlights.remove(index);
    } else {
      favoriteFlights.add(index);
    }
  }
}
