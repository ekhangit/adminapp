import 'dart:developer';

import 'package:dhs_app/models/leave_model.dart';
import 'package:dhs_app/services/base_service.dart';
import '../utils/api_config.dart';
import '../utils/response_class.dart';

class LeaveService {
  LeaveService._privateConstructor();
  static final LeaveService _instance = LeaveService._privateConstructor();
  static LeaveService get instance => _instance;

  /// Fetch all leave types
  Future<ResponseClass<List<LeaveTypeModel>>> leaveTypes() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.leaveTypes,
      );

      log("[leaveTypes] response : ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true &&
          response.data['body'] != null) {
        final List rawList = response.data['body'];

        final List<LeaveTypeModel> leaveType =
            rawList.map((e) => LeaveTypeModel.fromJson(e)).toList();

        return ResponseClass.success(leaveType);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  // Calculate total days between two dates
  Future<ResponseClass> calculateTotalDays({
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.calculateTotalDays,
        data: {"start_date": fromDate, "end_date": toDate},
      );

      log("[calculateTotalDays] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        final String totalDays = response.data['body'];
        return ResponseClass.success(totalDays);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  // Submit leave request
  Future<ResponseClass> submitLeaveRequest({
    required int leaveTypeId,
    required String fromDate,
    required String toDate,
    required int totalLeaveDays,
    required String leaveReason,
    String? profile,
  }) async {
    try {
      var data = {
        "leave_type_id": leaveTypeId,
        "start_date": fromDate,
        "end_date": toDate,
        "total_leave_days": totalLeaveDays,
        "leave_reason": leaveReason,
      };

      log("[submitLeaveRequest] data : $data");

      final response = await BaseService.instance.dio.post(
        ApiConfig.leaveRequest,
        data: data,
      );

      log("[submitLeaveRequest] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        return ResponseClass.success(response.data['message']);
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
