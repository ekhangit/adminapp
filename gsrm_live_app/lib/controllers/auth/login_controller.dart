import 'dart:developer';
import 'dart:io';

import 'package:gsrm_live_app/utils/app_colors.dart';
import 'package:gsrm_live_app/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../../services/base_service.dart';
import '../../utils/utils.dart';
import '../storage/data_storage_controller.dart';

class LoginController extends GetxController {
  static LoginController instance = Get.find();

  RxBool emailError = false.obs;
  RxBool passwordError = false.obs;

  var email = ''.obs;
  var password = ''.obs;

  var isLoading = false.obs;
  var passwordObscure = true.obs;

  void obscureChanged() {
    passwordObscure.value = !passwordObscure.value;
  }

  bool get canContinue => email.value.isNotEmpty && password.value.isNotEmpty;

  // **🔹 Get FCM Token Android**
  Future<String?> getFCMToken() async {
    final fcm = FirebaseMessaging.instance;
    return await fcm.getToken();
  }

  // **🔹 Get FCM Token iOS**
  Future<String?> getFCMAPNSToken() async {
    final fcm = FirebaseMessaging.instance;
    return await fcm.getAPNSToken();
  }

  // fahadcse8820@gmail.com
  // 123456

  /// **🔹 Login Function**
  Future<void> login() async {
    log("[LoginController] Login initiated");

    if (email.value.isEmpty || password.value.isEmpty) {
      log("[LoginController] Email or password is empty");
      emailError.value = email.value.isEmpty;
      passwordError.value = password.value.isEmpty;
      Utils.showSnackbar("Error", "All fields are required");
      return;
    }

    emailError.value = false;
    passwordError.value = false;
    _setLoading(true);

    try {
      log("[LoginController] Getting FCM token...");
      String? deviceToken;

      if (Platform.isIOS) {
        deviceToken = await getFCMAPNSToken();
      } else {
        deviceToken = await getFCMToken();
      }

      log("[LoginController] deviceToken $deviceToken");

      if (deviceToken == null) {
        log("[LoginController] FCM token is null");
        Utils.showFlushbar(
          Get.context!,
          "Failed to get device token",
          backgroundColor: AppColors.colorWarning,
        );
        return;
      }

      log("[LoginController] FCM token obtained: $deviceToken");

      log("[LoginController] Calling login API...");
      final response = await AuthService.instance.login(
        email: email.value,
        password: password.value,
        deviceType: Platform.isAndroid ? "android" : "ios",
        deviceToken: deviceToken,
      );

      log(
        "[LoginController] Login API response received: isSuccess = ${response.isSuccess}",
      );

      if (response.isSuccess && response.data!['status'] == true) {
        log("[LoginController] Login successful ✅");
        log("[LoginController] User data: ${response.data}");

        final loginResponse = response.data!['body'];
        if (loginResponse != null) {
          DataStorageController.to.createAccount(loginResponse);
          BaseService.instance.reloadHeaders();
        }

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInAnonymously();
        final firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          log("[LoginController] Firebase authenticated anonymously ✅");
        } else {
          log("[LoginController] Firebase authentication failed.");
          Utils.showFlushbar(
            Get.context!,
            "Firebase authentication failed",
            backgroundColor: AppColors.colorWarning,
          );
          return;
        }

        if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
          FocusManager.instance.primaryFocus?.unfocus();
          log("[LoginController] Keyboard dismissed");
          await Future.delayed(Duration(milliseconds: 200));
        }

        Get.offAll(() => MainScreen());

        Utils.showFlushbar(
          Get.context!,
          "Login Successfully.",
          backgroundColor: AppColors.colorSuccess,
        );
      } else {
        final message = response.data?['message'] ?? 'Login failed';
        log("[LoginController] Login failed ❌: $message");

        Utils.showFlushbar(
          Get.context!,
          message,
          backgroundColor: AppColors.colorWarning,
        );
      }
    } catch (e, stack) {
      log("[LoginController] Exception during login: $e");
      log("[LoginController] Stack trace: $stack");

      Utils.showFlushbar(
        Get.context!,
        "Something went wrong",
        backgroundColor: AppColors.colorWarning,
      );
    } finally {
      _setLoading(false);
      log("[LoginController] Login process completed");
    }
  }

  /// **🔹 Set Loading State with Animation**
  void _setLoading(bool state) {
    isLoading.value = state;
    if (state) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (isLoading.value) isLoading.value = false;
      });
    }
  }
}
