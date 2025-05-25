import 'dart:async';
import 'dart:developer';

import 'package:aviation_app/models/flight_model.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import '../../services/flight_comm_service.dart';

class FlightCommController extends GetxController {
  RxString formattedDateTime = ''.obs;
  late Timer _timer;

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
    'Cancelled',
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
