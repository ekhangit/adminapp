import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../controllers/flight/chat_controller.dart';
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
    controller: controller,
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

// Widget timerField({
//   required String label,
//   required TextEditingController controller,
//   VoidCallback? onTap,
//   bool? showHint = true,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         label,
//         style: const TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 14,
//           color: AppColors.colorPrimary,
//         ),
//       ),
//       const SizedBox(height: 8),
//       GestureDetector(
//         onTap: onTap,
//         child: AbsorbPointer(
//           child: TextField(
//             controller: controller,
//             readOnly: true,
//             decoration: InputDecoration(
//               prefixIcon: const Icon(Icons.access_time, size: 20),
//               hintText: showHint! ? "Select $label" : '',
//               filled: true,
//               fillColor: Colors.grey.shade100,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 10,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(color: Colors.grey.shade400, width: 0.2),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(
//                   color: Color(0xFF003862),
//                   width: 1.5,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }

Widget timerField2({
  required String label,
  String initialTime = '12:00',
  Color iconColor = Colors.white,
  Color borderColor = Colors.grey,
  double borderWidth = 0.2,
  double iconSize = 30,
  TextStyle? timeTextStyle,
  EdgeInsetsGeometry? padding,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11.0,
            color: AppColors.colorPrimary,
          ),
        ),
        const SizedBox(height: 4),

        // Time selector container
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: Column(
            children: [
              // Icon section
              Container(
                padding:
                    padding ??
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      AppColors.colorPrimary, // Changed from green to primary
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
                child: Icon(
                  Icons.access_time,
                  size: iconSize,
                  color: iconColor,
                ),
              ),

              // Time display section
              Container(
                padding:
                    padding ??
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(4),
                  ),
                ),
                child: Text(
                  initialTime,
                  style:
                      timeTextStyle ??
                      const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget timerField({
  required String label,
  required TextEditingController controller,
  VoidCallback? onTap,
  bool? showHint = true,
  int labelMaxLines = 1,
}) {
  final chatController = Get.find<ChatController>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: labelMaxLines == 2 ? 34 : null, // Approx. 2 lines height
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
            color: AppColors.colorPrimary,
          ),
          maxLines: labelMaxLines,
          textAlign: TextAlign.start,
        ),
      ),

      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: AbsorbPointer(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: AppColors.colorPrimary.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: const Icon(
                        Icons.access_time,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
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
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 0.2,
                      ),
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
          ),
          const SizedBox(width: 6),

          // Hour buttons
          _timeAdjustButtons(
            onIncrement:
                () => chatController.incrementTime(controller, isHour: true),
            onDecrement:
                () => chatController.decrementTime(controller, isHour: true),
          ),
          const SizedBox(width: 4),

          // Minute buttons
          _timeAdjustButtons(
            onIncrement:
                () => chatController.incrementTime(controller, isHour: false),
            onDecrement:
                () => chatController.decrementTime(controller, isHour: false),
          ),
        ],
      ),
    ],
  );
}

Widget _timeAdjustButtons({
  required VoidCallback onIncrement,
  required VoidCallback onDecrement,
}) {
  return Column(
    children: [
      _timeAdjustButton(icon: Icons.keyboard_arrow_up, onTap: onIncrement),
      const SizedBox(height: 1),
      _timeAdjustButton(icon: Icons.keyboard_arrow_down, onTap: onDecrement),
    ],
  );
}

Widget _timeAdjustButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 14, color: Colors.black87),
    ),
  );
}


class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, 
    TextEditingValue newValue,
  ) {
    // Handle deletion
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }
    
    // Auto-format as HHMM
    if (newValue.text.length == 2 && oldValue.text.length == 1) {
      return TextEditingValue(
        text: '${newValue.text}:',
        selection: TextSelection.collapsed(offset: 3),
      );
    }
    
    // Limit to 5 characters (HH:MM)
    if (newValue.text.length > 5) {
      return oldValue;
    }
    
    return newValue;
  }
}

