import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  final RxBool oldObscure = true.obs;
  final RxBool newObscure = true.obs;
  final RxBool confirmObscure = true.obs;

  final RxBool isLoading = false.obs;

  /// Returns an error message, or null when valid.
  String? validate() {
    if (oldPassword.text.isEmpty) return 'Enter your current password';
    if (newPassword.text.isEmpty) return 'Enter a new password';
    if (newPassword.text.length < 6) {
      return 'New password must be at least 6 characters';
    }
    if (newPassword.text != confirmPassword.text) {
      return 'New password and confirm password do not match';
    }
    return null;
  }

  Future<void> submit() async {
    // No change-password endpoint yet — hook the API call here later.
  }

  @override
  void onClose() {
    oldPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
