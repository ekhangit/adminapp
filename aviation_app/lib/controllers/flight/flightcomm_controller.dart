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
}
