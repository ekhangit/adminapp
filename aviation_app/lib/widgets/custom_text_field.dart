import 'package:aviation_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final bool isPasswordField;
  final Function(String)? onChanged;
  final Function? onShow;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.isPasswordField = false,
    this.onChanged,
    this.onShow,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black),
      onChanged: onChanged,
      cursorColor: AppColors.colorPrimary,
      cursorWidth: 2.5,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        errorText: errorText, // Show error message
        suffixIcon:
            isPasswordField
                ? IconButton(
                  onPressed: () => onShow?.call(),
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 0.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.colorPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.colorWarning),
        ),
      ),
    );
  }
}
