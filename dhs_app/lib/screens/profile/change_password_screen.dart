import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';
import '../../controllers/profile/change_password_controller.dart';
import '../../utils/app_colors.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ChangePasswordController());

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: appThemeGradientSoft2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Change Password',
          style: GoogleFonts.rajdhani(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: AppColors.colorPrimary,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Update your password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.matteBlackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Use at least 6 characters for your new password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          // Card with the fields
          Container(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _passwordField(
                  'Current Password',
                  c.oldPassword,
                  c.oldObscure,
                  hint: 'Enter current password',
                ),
                _passwordField(
                  'New Password',
                  c.newPassword,
                  c.newObscure,
                  hint: 'Enter new password',
                ),
                _passwordField(
                  'Confirm Password',
                  c.confirmPassword,
                  c.confirmObscure,
                  hint: 'Re-enter new password',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _onSubmit(context, c),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Update Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordField(
    String label,
    TextEditingController controller,
    RxBool obscure, {
    String? hint,
  }) {
    OutlineInputBorder border(Color col) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: col),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.matteBlackColor,
              ),
            ),
          ),
          Obx(
            () => TextField(
              controller: controller,
              obscureText: obscure.value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    TextStyle(color: Colors.grey.shade400, fontSize: 13.5),
                isDense: true,
                filled: true,
                fillColor: const Color(0xFFF6F7F9),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                border: border(Colors.grey.shade200),
                enabledBorder: border(Colors.grey.shade200),
                focusedBorder: border(AppColors.colorPrimary),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: Colors.grey.shade500,
                  ),
                  onPressed: obscure.toggle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit(BuildContext context, ChangePasswordController c) {
    final error = c.validate();
    if (error != null) {
      _toast(context, error, isError: true);
      return;
    }
    c.submit();
    _toast(context, 'Changing password will be available soon.');
  }

  void _toast(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor:
            isError ? AppColors.colorWarning : AppColors.colorPrimary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
