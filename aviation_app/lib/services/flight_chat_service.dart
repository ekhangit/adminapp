import 'dart:developer';

import 'package:aviation_app/models/chat_model.dart';
import 'package:aviation_app/models/flight_no_model.dart';
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

      // log("[allFlightComm] response : ${response.data}");

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

  Future<ResponseClass<List<ChatMessage>>> flightChats({
    required int flightId,
  }) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getFlightChats,
        data: {"flight_id": flightId},
      );

      log("[flightChats] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        final List rawList = response.data['body'];

        final List<ChatMessage> chatMessages =
            rawList.map((e) => ChatMessage.fromJson(e)).toList();

        return ResponseClass.success(chatMessages);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  // Send ARR
  Future<ResponseClass<bool>> sendArr(Map<String, dynamic> data) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.sendArr,
        data: data,
      );

      log("[sendArr] response : ${response.data}");

      return ResponseClass.success(true);
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  // Send DSR
  Future<ResponseClass<List<FlightNoModel>>> allFlightNo() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getAllFlightNo,
      );

      // log("[allFlightNo] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        final List rawList = response.data['body'];

        final List<FlightNoModel> flightNos =
            rawList.map((e) => FlightNoModel.fromJson(e)).toList();

        return ResponseClass.success(flightNos);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  Future<ResponseClass<bool>> sendDsr(Map<String, dynamic> data) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.sendDsr,
        data: data,
      );

      log("[sendDsr] response : ${response.data}");

      return ResponseClass.success(true);
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  // Send FHR
  Future<ResponseClass<bool>> sendFhr(Map<String, dynamic> data) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.sendFhr,
        data: data,
      );

      log("[sendFhr] response : ${response.data}");

      return ResponseClass.success(true);
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }
}
