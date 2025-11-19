import 'dart:developer';

import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/utils.dart';
import '../storage/data_storage_controller.dart';

class ProfileController extends GetxController {
  static ProfileController instance = Get.find();

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
        final message = response.data?['message'] ?? 'Logout API failed';
        log("[ProfileController] ⚠️ Logout API failed: $message");

        // Even if API fails, clear session and logout locally
        await DataStorageController.to.clearSession();
        Get.offAllNamed("/login");

        Utils.showFlushbar(
          Get.context!,
          "Logged out successfully.",
          backgroundColor: AppColors.colorSuccess,
        );
      }
    } catch (e, stack) {
      log("[ProfileController] ❌ Logout exception: $e");
      log("[ProfileController] Stack trace:\n$stack");

      // Even on exception, clear session and logout locally
      await DataStorageController.to.clearSession();
      Get.offAllNamed("/login");

      Utils.showFlushbar(
        Get.context!,
        "Logged out successfully.",
        backgroundColor: AppColors.colorSuccess,
      );
    }
  }
}
