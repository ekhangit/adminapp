import 'package:aviation_app/services/base_service.dart';

import '../utils/api_config.dart';

class AttendanceService {
  AttendanceService._privateConstructor();
  static final AttendanceService _instance =
      AttendanceService._privateConstructor();
  static AttendanceService get instance => _instance;

  /// 🔐 Clock In API
  Future<bool> clockIn() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.clockInAPI,
      );

      if (response.statusCode == 200) {
        print("Clock-in successful: ${response.data}");
        return true;
      } else {
        print("Clock-in failed with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Clock-in failed: $e");
      return false;
    }
  }

  /// 🔐 Clock Out API
  Future<bool> clockOut() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.clockOutAPI,
      );

      if (response.statusCode == 200) {
        print("Clock-out successful: ${response.data}");
        return true;
      } else {
        print("Clock-out failed with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Clock-out failed: $e");
      return false;
    }
  }
}
