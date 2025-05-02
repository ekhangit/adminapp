import 'package:get/get.dart';

class FlightCommController extends GetxController {
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
