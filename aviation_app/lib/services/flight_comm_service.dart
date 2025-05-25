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
  Future<ResponseClass<Map<String, List<FlightsModel>>>> allFlightComm({
    required String date,
  }) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.allFlightComm,
        data: {"date": date},
      );

      log("[allFlightComm] response : ${response.data}");

      final body = response.data['body'];

      Map<String, List<FlightsModel>> flightsMap = {
        'all_flights':
            (body['all_flights'] as List?)
                ?.map((f) => FlightsModel.fromJson(f))
                .toList() ??
            [],
        'departure_flights':
            (body['departure_flights'] as List?)
                ?.map((f) => FlightsModel.fromJson(f))
                .toList() ??
            [],
        'arrival_flights':
            (body['arrival_flights'] as List?)
                ?.map((f) => FlightsModel.fromJson(f))
                .toList() ??
            [],
        'cancelled_flights':
            (body['cancelled_flights'] as List?)
                ?.map((f) => FlightsModel.fromJson(f))
                .toList() ??
            [],
        'my_flights':
            (body['my_flights'] as List?)
                ?.map((f) => FlightsModel.fromJson(f))
                .toList() ??
            [],
      };

      // log("[allFlightComm] flightsMap : $flightsMap");

      return ResponseClass.success(flightsMap);
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

}
