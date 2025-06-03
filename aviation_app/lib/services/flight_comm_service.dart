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

      // log("[allFlightComm] response : ${response.data}");

      final body = response.data['body'];

      log("[allFlightComm] All Response : ${body['all_flights']}");

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

  Future<ResponseClass> flightAddToFavourite({required int flightId}) async {
    try {
      log("[flightAddToFavourite] apiUrl : ${ApiConfig.favFlightComm}");
      log("[flightAddToFavourite] flight_id : $flightId");

      final response = await BaseService.instance.dio.post(
        ApiConfig.favFlightComm,
        data: {"flight_id": flightId},
      );

      log("[flightAddToFavourite] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        return ResponseClass.success('Flight added to favorites successfully');
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }
}
