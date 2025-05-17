import 'dart:async';
import 'dart:developer';

import 'package:aviation_app/models/flight_model.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import '../../services/flightcomm_service.dart';

class FlightCommController extends GetxController {
  RxString formattedDateTime = ''.obs;
  late Timer _timer;

  var allFlights = <FlightsModel>[].obs;
  var isFlightCommLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startDateTimeUpdater();
    fetchFlightComm();
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

  var selectedFilter = 'All'.obs;

  final List<String> filters = [
    'My Flights',
    'All',
    'Arrivals',
    'Departures',
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

  Future<void> fetchFlightComm() async {
    isFlightCommLoading.value = true;

    try {
      final now = DateTime.now().toUtc();
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);

      log('[FlightCommController] formattedDate: $formattedDate');

      final response = await FlightCommService.instance.allFlightComm(
        date: formattedDate,
        type: 'all',
      );
      if (response.isSuccess) {
        allFlights.assignAll(response.data!);
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

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  void toggleFavorite(int index) {
    if (favoriteFlights.contains(index)) {
      favoriteFlights.remove(index);
    } else {
      favoriteFlights.add(index);
    }
  }
}
