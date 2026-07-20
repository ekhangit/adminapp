import 'package:another_flushbar/flushbar.dart';
import 'package:dhs_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  /// **🔹 Show Snackbar for Messages**
  static showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      duration: Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  }

  static showFlushbar(
    BuildContext context,
    String message, {
    Color? backgroundColor = AppColors.matteBlackColor,
  }) {
    Flushbar(
      duration: Duration(seconds: 3),
      backgroundColor: backgroundColor!,
      flushbarPosition: FlushbarPosition.TOP,
      messageText: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      flushbarStyle: FlushbarStyle.GROUNDED,
    ).show(context);
  }
}
