import 'dart:developer';

import 'package:aviation_app/models/flight_model.dart';
import 'package:aviation_app/services/base_service.dart';
import 'package:aviation_app/utils/api_config.dart';
import 'package:aviation_app/utils/response_class.dart';

class FlightCommService {
  FlightCommService._privateConstructor();
  static final FlightCommService _instance =
      FlightCommService._privateConstructor();
  static FlightCommService get instance => _instance;

  /// Fetch all flight communications
  Future<ResponseClass<List<FlightsModel>>> allFlightComm({required String date, required String type}) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.allFlightComm,
        data: {"date": date, "type": type},
      );

      log("[allFlightComm] response : ${response.data}");

      var flightsList = response.data['body']['flights'] as List;

      log("[allFlightComm] flightsList  total : ${flightsList.length}");

      List<FlightsModel> flights =
          flightsList.map((f) => FlightsModel.fromJson(f)).toList();

      return ResponseClass.success(flights);
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }
}
