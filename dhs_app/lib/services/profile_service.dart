import 'dart:developer';

import '../models/emp_profile_model.dart';
import '../utils/api_config.dart';
import '../utils/response_class.dart';
import 'base_service.dart';

class ProfileService {
  ProfileService._privateConstructor();
  static final ProfileService _instance = ProfileService._privateConstructor();
  static ProfileService get instance => _instance;

  /// 👤 Employee profile (Profile tab)
  Future<ResponseClass<EmpProfileData>> getEmpData(int userId) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getEmpData,
        data: {'user_id': userId},
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return ResponseClass.success(
          EmpProfileData.fromJson(
            Map<String, dynamic>.from(response.data['data'] ?? {}),
          ),
        );
      }
      return ResponseClass.error(
        response.data['message'] ?? 'Failed to fetch profile',
      );
    } catch (e) {
      log('[ProfileService] getEmpData error: $e');
      return ResponseClass.error(e.toString());
    }
  }

  /// 📄 Employee detail (Detail tab)
  Future<ResponseClass<EmpDetailData>> getEmpDetail(int userId) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getEmpDetail,
        data: {'user_id': userId},
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return ResponseClass.success(
          EmpDetailData.fromJson(
            Map<String, dynamic>.from(response.data['data'] ?? {}),
          ),
        );
      }
      return ResponseClass.error(
        response.data['message'] ?? 'Failed to fetch detail',
      );
    } catch (e) {
      log('[ProfileService] getEmpDetail error: $e');
      return ResponseClass.error(e.toString());
    }
  }

  /// 💾 Update employee profile (Profile tab)
  Future<ResponseClass<String>> updateEmpData(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.updateEmpData,
        data: body,
      );
      if (response.statusCode == 200 && response.data['status'] == true) {
        return ResponseClass.success(
          response.data['message']?.toString() ?? 'Profile updated',
        );
      }
      return ResponseClass.error(
        response.data['message'] ?? 'Failed to update profile',
      );
    } catch (e) {
      log('[ProfileService] updateEmpData error: $e');
      return ResponseClass.error(e.toString());
    }
  }

  /// 💾 Update employee detail (Detail tab)
  Future<ResponseClass<String>> updateEmpDetail(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.updateEmpDetail,
        data: body,
      );
      if (response.statusCode == 200 && response.data['status'] == true) {
        return ResponseClass.success(
          response.data['message']?.toString() ?? 'Detail updated',
        );
      }
      return ResponseClass.error(
        response.data['message'] ?? 'Failed to update detail',
      );
    } catch (e) {
      log('[ProfileService] updateEmpDetail error: $e');
      return ResponseClass.error(e.toString());
    }
  }
}
