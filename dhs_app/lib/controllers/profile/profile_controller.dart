import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/utils.dart';
import '../storage/data_storage_controller.dart';

class ProfileController extends GetxController {
  static ProfileController instance = Get.find();

  /// 🔔 Push notification enabled state (local for now).
  final RxBool pushEnabled = true.obs;

  void togglePush(bool value) {
    pushEnabled.value = value;
    log("[ProfileController] Push notifications ${value ? 'enabled' : 'disabled'}");
    // Later: wire to FirebaseMessaging subscribe/unsubscribe or backend setting.
  }

  /// 🌗 Dark mode state.
  final RxBool darkMode = false.obs;

  void toggleDarkMode(bool value) {
    darkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    log("[ProfileController] Dark mode ${value ? 'on' : 'off'}");
    // Later: persist preference and define a full dark theme in GetMaterialApp.
  }

  /// 🔐 Logout Function
  Future<void> logout() async {
    log("[ProfileController] 🔒 Logout initiated");

    try {
      final response = await AuthService.instance.logout();
      log("[ProfileController] ✅ Logout API response: ${response.data}");

      if (response.isSuccess && (response.data?['status'] == true)) {
        // ✅ Clear session
        await DataStorageController.to.clearSession();

        // ✅ Navigate to Login Screen
        Get.offAllNamed("/login");

        // ✅ Feedback
        Utils.showFlushbar(
          Get.context!,
          "Logged out successfully.",
          backgroundColor: AppColors.colorSuccess,
        );
      } else {
        final message = response.data?['message'] ?? 'Logout failed';
        log("[ProfileController] ⚠️ Logout API failed: $message");

        Utils.showFlushbar(
          Get.context!,
          message,
          backgroundColor: AppColors.colorWarning,
        );
      }
    } catch (e, stack) {
      log("[ProfileController] ❌ Logout exception: $e");
      log("[ProfileController] Stack trace:\n$stack");

      Utils.showFlushbar(
        Get.context!,
        "Logout failed. Try again.",
        backgroundColor: AppColors.colorWarning,
      );
    }
  }
}
