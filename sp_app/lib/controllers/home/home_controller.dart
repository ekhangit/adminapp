import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sp_app/screens/auth/login_screen.dart';
import 'package:sp_app/services/auth_service.dart';
import 'package:sp_app/services/notification_service.dart';
import 'package:sp_app/controllers/storage/data_storage_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();

  /// **🔹 Logout Function**
  Future<void> logout() async {
    try {
      log('[HomeController] Logout initiated');

      // 1. Disable notifications and clear all
      log('[HomeController] Disabling notifications...');
      await NotificationService.instance.disableNotifications();

      // 2. Call logout API
      log('[HomeController] Calling logout API...');
      await AuthService.instance.logout();

      // 3. Sign out from Firebase
      log('[HomeController] Signing out from Firebase...');
      await FirebaseAuth.instance.signOut();

      // 4. Clear local session
      log('[HomeController] Clearing local session...');
      await DataStorageController.to.clearSession();

      // 5. Navigate to login screen
      log('[HomeController] Navigating to login screen...');
      Get.offAll(() => const LoginScreen());

      log('[HomeController] Logout completed successfully ✅');
    } catch (e, stack) {
      log('[HomeController] Logout error: $e');
      log('[HomeController] Stack trace: $stack');

      // Even if there's an error, still navigate to login screen
      Get.offAll(() => const LoginScreen());
    }
  }
}
