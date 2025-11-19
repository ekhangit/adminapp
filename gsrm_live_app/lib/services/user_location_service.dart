import 'dart:developer';

import 'package:gsrm_live_app/services/base_service.dart';

import '../utils/api_config.dart';
import '../utils/response_class.dart';

class UserLocationService {
  UserLocationService._privateConstructor();
  static final UserLocationService _instance =
      UserLocationService._privateConstructor();
  static UserLocationService get instance => _instance;

  // Check Location Permission
  Future<ResponseClass<Map<String, dynamic>?>> checkLocation() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.checkLocationPermissionAPI,
      );

      log("[checkLocation] Response: ${response.data}");

      var data = response.data['body'] as Map<String, dynamic>?;

      return ResponseClass.success(data);
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }
}
