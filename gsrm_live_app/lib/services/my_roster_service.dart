import 'dart:developer';

import 'package:gsrm_live_app/services/base_service.dart';

import '../models/roster_models.dart';
import '../utils/api_config.dart';
import '../utils/response_class.dart';

class MyRosterService {
  MyRosterService._privateConstructor();
  static final MyRosterService _instance =
      MyRosterService._privateConstructor();
  static MyRosterService get instance => _instance;

  Future<ResponseClass> todayRoster() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.toadyRoster,
      );

      log("[todayRoster] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        // FIX: Actually parse the response data
        final todayRoster = TodayRoster.fromJson(response.data['body']);
        log('Today Roster: $todayRoster');

        return ResponseClass.success(todayRoster); // Return the parsed data
      } else {
        log("[todayRoster] Error: ${response.data['message']}");

        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      log("[todayRoster] Exception: $e");
      return ResponseClass.error(e.toString());
    }
  }

  Future<ResponseClass<List<Week>>> monthlyRoster() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.monthlyRoster,
      );

      // log("[monthlyRoster] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        // FIX: Actually parse the response data

        final List<Week> monthlyRosterList =
            (response.data['body']['weeks'] as List)
                .map((e) => Week.fromJson(e))
                .toList();
        // log('Monthly Roster List: $monthlyRosterList');
        return ResponseClass.success(monthlyRosterList);
      } else {
        log("[monthlyRoster] Error: ${response.data['message']}");

        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      log("[monthlyRoster] Exception: $e");
      return ResponseClass.error(e.toString());
    }
  }

  Future<ResponseClass<List<Week>>> customRangeRoster({
    required String fromDate,
    required String toDate,
  }) async {
    try {
      log("[customRangeRoster] fromDate: $fromDate, toDate: $toDate");

      final response = await BaseService.instance.dio.post(
        ApiConfig.customRoster,
        data: {"fromDate": fromDate, "toDate": toDate},
      );

      log("[customRangeRoster] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        // FIX: Actually parse the response data

        final List<Week> monthlyRosterList =
            (response.data['body']['weeks'] as List)
                .map((e) => Week.fromJson(e))
                .toList();
        log('[customRangeRoster] List: $monthlyRosterList');
        return ResponseClass.success(monthlyRosterList);
      } else {
        log("[customRangeRoster] Error: ${response.data['message']}");

        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      log("[customRangeRoster] Exception: $e");
      return ResponseClass.error(e.toString());
    }
  }

  // Add break time entry
  Future<ResponseClass> addBreakTime({
    required int employeeId,
    required String breakDate,
    required List<Map<String, String>> breakTimes,
  }) async {
    log(
      "[addBreakTime] employeeId: $employeeId, breakDate: $breakDate, breakTimes: $breakTimes",
    );

    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.addBreakTimeRoster,
        data: {
          "employee_Id": employeeId,
          "break_date": breakDate,
          "break_times": breakTimes,
        },
      );

      log("[addBreakTime] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        return ResponseClass.success(
          response.data['body'] ?? 'Break time added successfully',
        );
      } else {
        log("[addBreakTime] Error: ${response.data['error_code']}");
        return ResponseClass.error(
          response.data['error_code'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      log("[addBreakTime] Exception: $e");
      return ResponseClass.error(e.toString());
    }
  }

  // Mark Duty
  Future<ResponseClass> markDuty({
    required int dutyId,
    required String actualTimeIn,
    required String actualTimeOut,
  }) async {
    log(
      "[markDuty] dutyId: $dutyId, actualTimeIn: $actualTimeIn, actualTimeOut: $actualTimeOut",
    );

    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.markDutyRoster,
        data: {
          "id": dutyId,
          "actual_time_in": actualTimeIn,
          "actual_time_out": actualTimeOut,
        },
      );

      log("[markDuty] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        return ResponseClass.success(
          response.data['body'] ?? 'Duty marked successfully',
        );
      } else {
        log("[markDuty] Error: ${response.data['error_code']}");
        return ResponseClass.error(
          response.data['error_code'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      log("[markDuty] Exception: $e");
      return ResponseClass.error(e.toString());
    }
  }
}
