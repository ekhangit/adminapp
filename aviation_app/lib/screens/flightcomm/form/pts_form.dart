import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';
import '../../../utils/app_colors.dart';

class PTSForm extends StatelessWidget {
  const PTSForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _timeRadio(
                    label: "UTC TIME",
                    value: "UTC",
                    groupValue: controller.selectedTimeMode.value,
                    onChanged:
                        (val) => controller.selectedTimeMode.value = val!,
                  ),
                  const SizedBox(width: 20),
                  _timeRadio(
                    label: "LOCAL TIME",
                    value: "Local",
                    groupValue: controller.selectedTimeMode.value,
                    onChanged:
                        (val) => controller.selectedTimeMode.value = val!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeRadio({
    required String label,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: AppColors.colorSuccess,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 13.5, color: Colors.red)),
      ],
    );
  }
}
