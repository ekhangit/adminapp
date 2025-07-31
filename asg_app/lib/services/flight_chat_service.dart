import 'dart:developer';

import 'package:asg_app/models/aircraft_model.dart';
import 'package:asg_app/models/airline_model.dart';
import 'package:asg_app/models/chat_model.dart';
import 'package:asg_app/models/flight_no_model.dart';
import 'package:asg_app/models/staff_model.dart';
import 'package:asg_app/services/base_service.dart';

import '../models/flight_detail_model.dart';
import '../utils/api_config.dart';
import '../utils/response_class.dart';

class FlightChatService {
  FlightChatService._privateConstructor();
  static final FlightChatService _instance =
      FlightChatService._privateConstructor();
  static FlightChatService get instance => _instance;

  // CHAT
  Future<ResponseClass<FlightDetailModel>> flightChatDetail({
    required int flightId,
  }) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getFlightDetail,
        data: {"flight_id": flightId},
      );

      log("[flightChatDetail] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        // log(
        //   "[flightChatDetail] response basicDetail : ${response.data['body']['flight_info']['basic_details']}",
        // );
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

  Future<ResponseClass<List<StaffModel>>> flightStaff() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getFlightStaff,
      );

      // log("[flightStaff] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        final List rawList = response.data['body'];

        final List<StaffModel> flightStaff =
            rawList.map((e) => StaffModel.fromJson(e)).toList();

        return ResponseClass.success(flightStaff);
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

  // Send Chat

  Future<ResponseClass<bool>> sendMessage(Map<String, dynamic> data) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.sendMessage,
        data: data,
      );

      log("[sendMessage] response : ${response.data}");

      return ResponseClass.success(true);
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

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

  Future<ResponseClass<List<FlightNoModel>>> allFlightNoWithFlightId({
    required int flightId,
  }) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getFlightNo,
        data: {"flight_id": flightId},
      );

      // log("[allFlightNoWithFlightId] Api Response : ${response.data}");

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

  Future<ResponseClass<List<String>>> getSSROption({
    required int flightId,
  }) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getSSROption,
        data: {"flight_id": flightId},
      );

      // log("[getSSROption] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        final List rawList = response.data['body'];

        final List<String> ssrData = rawList.map((e) => e.toString()).toList();

        return ResponseClass.success(ssrData);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  Future<ResponseClass<List<AircraftTypeModel>>> aircraftTypes({
    required int flightId,
  }) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getAircraftType,
        data: {"flight_id": flightId},
      );

      // log("[aircraftTypes] Api Response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        final List rawList = response.data['body'];

        final List<AircraftTypeModel> aircraftTypes =
            rawList.map((e) => AircraftTypeModel.fromJson(e)).toList();

        return ResponseClass.success(aircraftTypes);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  Future<ResponseClass<List<AircraftRegModel>>> aircraftReg({
    required int flightId,
  }) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getAircraftReg,
        data: {"flight_id": flightId},
      );

      // log("[aircraftReg] Api Response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        final List rawList = response.data['body'];

        final List<AircraftRegModel> aircraftReg =
            rawList.map((e) => AircraftRegModel.fromJson(e)).toList();

        return ResponseClass.success(aircraftReg);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  Future<ResponseClass<List<AirlineModel>>> getAirlines() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getAirlines,
      );

      // log("[getAirlines] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        final List rawList = response.data['body'];

        final List<AirlineModel> airlinesData =
            rawList.map((e) => AirlineModel.fromJson(e)).toList();

        return ResponseClass.success(airlinesData);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  Future<ResponseClass<List<FlightNoModel>>> getAirlineFlightNumber({
    required int airlineId,
  }) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getAirlineFlightNo,
        data: {"airline_id": airlineId},
      );

      // log("[getAirlineFlightNumber] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        final List rawList = response.data['body'];

        final List<FlightNoModel> airlineFlightNumData =
            rawList.map((e) => FlightNoModel.fromJson(e)).toList();

        return ResponseClass.success(airlineFlightNumData);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  Future<ResponseClass<List<AirportModel>>> getAirport() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getAirports,
      );

      // log("[getAirport] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        final List rawList = response.data['body'];

        final List<AirportModel> airportsData =
            rawList.map((e) => AirportModel.fromJson(e)).toList();

        return ResponseClass.success(airportsData);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  Future<ResponseClass<List<String>>> getPTSOption({
    required int flightId,
  }) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getPTSOption,
        data: {"flight_id": flightId},
      );

      log("[getPTSOption] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        final dynamic body = response.data['body'];

        List<String> ptsData = [];

        // Handle both list and map responses
        if (body is List) {
          ptsData = body.map((e) => e.toString()).toList();
        } else if (body is Map) {
          // Convert map keys to list if needed
          ptsData = body.keys.map((k) => k.toString()).toList();
          // OR if you want values:
          // ptsData = body.values.map((v) => v.toString()).toList();
        }

        return ResponseClass.success(ptsData);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      log("Error in getPTSOption: $e");
      return ResponseClass.error(e.toString());
    }
  }

  // Send SSR

  Future<ResponseClass<bool>> sendSsr(Map<String, dynamic> data) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.sendSsr,
        data: data,
      );

      log("[sendSsr] response : ${response.data}");

      return ResponseClass.success(true);
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

  // Send PTS

  Future<ResponseClass<bool>> sendPts(Map<String, dynamic> data) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.sendPTS,
        data: data,
      );

      log("[sendPts] response : ${response.data}");

      return ResponseClass.success(true);
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  // Send DSR

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

  // Send OCC

  Future<ResponseClass<bool>> sendOCC(Map<String, dynamic> data) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.sendOcc,
        data: data,
      );

      log("[sendOCC] response : ${response.data}");

      return ResponseClass.success(true);
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }
}
