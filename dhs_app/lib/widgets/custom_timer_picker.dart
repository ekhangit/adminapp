import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class TimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimePickerField({
    super.key,
    required this.label,
    required this.initialTime,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialTime.format(context));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: initialTime,
                );
                if (time != null) {
                  controller.text = time.format(Get.context!);
                  onTimeChanged(time);
                }
              },
            ),
          ),
          readOnly: true,
        ),
      ],
    );
  }
}
