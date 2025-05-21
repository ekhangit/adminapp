import 'dart:developer';

import 'package:aviation_app/services/base_service.dart';

import '../models/flight_detail_model.dart';
import '../utils/api_config.dart';
import '../utils/response_class.dart';

class FlightChatService {
  FlightChatService._privateConstructor();
  static final FlightChatService _instance =
      FlightChatService._privateConstructor();
  static FlightChatService get instance => _instance;

  Future<ResponseClass<FlightDetailModel>> flightChatDetail({
    required int flightId,
  }) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getFlightDetail,
        data: {"flight_id": flightId},
      );

      log("[allFlightComm] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        final flightDetail = FlightDetailModel.fromJson(response.data['body']);
        return ResponseClass.success(flightDetail);
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
