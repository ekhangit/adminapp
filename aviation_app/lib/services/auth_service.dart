import 'package:aviation_app/services/base_service.dart';
import 'package:aviation_app/utils/api_config.dart';

import '../utils/response_class.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService _instance = AuthService._privateConstructor();
  static AuthService get instance => _instance;

  /// 🔐 Login API
  Future<ResponseClass<Map<String, dynamic>>> login({
    required String email,
    required String password,
    required String deviceType,
    required String deviceToken,
  }) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.loginAPI,
        data: {
          "email": email,
          "password": password,
          "device_type": deviceType,
          "device_token": deviceToken,
        },
      );

      return ResponseClass.success(response.data);
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  /// 🔁 FCM Token Update
  Future<ResponseClass<void>> setFCMToken(String fcmToken) async {
    try {
      final response = await BaseService.instance.dio.post(
        "/profile/update_token",
        data: {"token": fcmToken},
      );
      return ResponseClass.success(null);
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }
}
