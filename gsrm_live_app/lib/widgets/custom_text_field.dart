import 'package:gsrm_live_app/utils/app_colors.dart';
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

class CustomTextFieldWithLabel extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final bool isPasswordField;
  final Function(String)? onChanged;
  final Function? onShow;
  final String? errorText;
  final int maxLines;

  const CustomTextFieldWithLabel({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.isPasswordField = false,
    this.onChanged,
    this.onShow,
    this.errorText,
    this.maxLines = 1, // 🔹 default to 1 for normal input
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // 🔹 TextField
        TextField(
          obscureText: obscureText,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.black),
          onChanged: onChanged,
          cursorColor: AppColors.colorPrimary,
          cursorWidth: 2.5,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            errorText: errorText,
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
        ),
      ],
    );
  }
}
