import 'package:aviation_app/models/airline_model.dart';
import 'package:aviation_app/services/flight_chat_service.dart';
import 'package:get/get.dart';

class AirlineController extends GetxController {
  static AirlineController get to => Get.find<AirlineController>();

  // Cached airlines list
  var airlines = <AirlineModel>[].obs;
  var isLoading = false.obs;
  var isLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch airlines when controller is initialized
    fetchAirlines();
  }

  /// Fetch airlines and cache them
  Future<void> fetchAirlines() async {
    if (isLoaded.value) return; // Already loaded, use cache

    try {
      isLoading.value = true;
      final response = await FlightChatService.instance.getAirlines();

      if (response.isSuccess && response.data != null) {
        airlines.value = response.data!;
        isLoaded.value = true;
      }
    } catch (e) {
      print('[AirlineController] Error fetching airlines: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get airline logo URL by airline ID
  String? getAirlineLogoById(int? airlineId) {
    if (airlineId == null) return null;
    final airline = airlines.firstWhereOrNull((a) => a.id == airlineId);
    return airline?.logoUrl;
  }

  /// Get airline by ID
  AirlineModel? getAirlineById(int? airlineId) {
    if (airlineId == null) return null;
    return airlines.firstWhereOrNull((a) => a.id == airlineId);
  }

  /// Get airline by IATA code
  AirlineModel? getAirlineByIata(String? iata) {
    if (iata == null || iata.isEmpty) return null;
    return airlines.firstWhereOrNull((a) => a.iata == iata);
  }

  /// Get airline by ICAO code
  AirlineModel? getAirlineByIcao(String? icao) {
    if (icao == null || icao.isEmpty) return null;
    return airlines.firstWhereOrNull((a) => a.icao == icao);
  }

  /// Force refresh airlines (clear cache and fetch again)
  Future<void> refreshAirlines() async {
    isLoaded.value = false;
    await fetchAirlines();
  }
}
