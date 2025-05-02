import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';

Widget formRow(String label1, String label2) {
  return Row(
    children: [
      Expanded(child: _formField(label1)),
      const SizedBox(width: 12),
      Expanded(child: _formField(label2)),
    ],
  );
}

Widget singleField(
  String label, {
  bool showLabel = true,
  bool showSelect = false,
  bool disbaleHint = false,
  int maxLines = 1,
  TextEditingController? controller,
}) {
  return _formField(
    label,
    maxLines: maxLines,
    showLabel: showLabel,
    showSelect: showSelect,
    disbaleHint: disbaleHint,
  );
}

Widget _formField(
  String label, {
  bool showLabel = true,
  bool showSelect = false,
  bool disbaleHint = false,

  int maxLines = 1,
  TextEditingController? controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (showLabel)
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      if (showLabel) const SizedBox(height: 6),
      TextField(
        maxLines: maxLines,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

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
          filled: true,
          fillColor: Colors.grey.shade100,
          hintText:
              !disbaleHint
                  ? showSelect
                      ? "Select $label"
                      : "Enter $label"
                  : null,
        ),
      ),
    ],
  );
}

Widget timerField({
  required String label,
  required TextEditingController controller,
  VoidCallback? onTap,
  bool? showHint = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.colorPrimary,
        ),
      ),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.access_time, size: 20),
              hintText: showHint! ? "Select $label" : '',
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 0.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF003862),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
