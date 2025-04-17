import 'package:aviation_app/screens/leave/widget/leave_mode_chip.dart';
import 'package:aviation_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard/leave_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_text_field.dart';

import 'package:intl/intl.dart';

class LeaveRequestScreen extends StatelessWidget {
  const LeaveRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LeaveRequestController controller = Get.put(LeaveRequestController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Leave Request",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.colorPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFieldWithLabel(
              label: "Description",
              hintText: "Write your message or description...",
              maxLines: 5, // 🔹 allows for multiline input
              onChanged: (val) => controller.description.value = val,
            ),
            SizedBox(height: 20),
            CustomTextFieldWithLabel(
              label: "Leave Reason",
              hintText: "Write your leave reason...",
              onChanged: (val) => controller.reason.value = val,
            ),

            const SizedBox(height: 20),

            // 🔹 Leave Mode Title
            const Text(
              "Leave Mode",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            // 🔹 Chips
            Obx(
              () => Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    controller.leaveModes.map((mode) {
                      return LeaveModeChip(
                        label: mode,
                        isSelected: controller.selectedMode.value == mode,
                        onTap: () => controller.selectMode(mode),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            Obx(
              () => DatePickerFieldWithLabel(
                label: "From",
                selectedDate: controller.fromDate.value,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(), // ⛔ Prevent past dates
                    lastDate: DateTime(2100),
                    builder:
                        (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF003862),
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        ),
                  );
                  if (picked != null) {
                    controller.fromDate.value = DateFormat(
                      'dd MMM, yyyy',
                    ).format(picked);
                  }
                },
              ),
            ),

            const SizedBox(height: 16),

            Obx(
              () => DatePickerFieldWithLabel(
                label: "To",
                selectedDate: controller.toDate.value,
                onTap: () async {
                  DateTime firstAvailableDate = DateTime.now();

                  // If fromDate already selected, parse it and use that as the start
                  if (controller.fromDate.value.isNotEmpty) {
                    firstAvailableDate = DateFormat(
                      'dd MMM, yyyy',
                    ).parse(controller.fromDate.value);
                  }

                  final picked = await showDatePicker(
                    context: context,
                    initialDate: firstAvailableDate,
                    firstDate:
                        firstAvailableDate, // ⛔ Prevent selecting before "From" date
                    lastDate: DateTime(2100),
                    builder:
                        (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFFC70039),
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        ),
                  );
                  if (picked != null) {
                    controller.toDate.value = DateFormat(
                      'dd MMM, yyyy',
                    ).format(picked);
                  }
                },
              ),
            ),

            const SizedBox(height: 30),

            Obx(
              () => CustomButton(
                text: "Submit",
                onPressed: () => controller.submitRequest(),
                color: AppColors.buttonColor1,
                disabled: !controller.canContinue,
                isLoading: controller.isLoading.value,
                borerRadius: 8,
                loadingWidget: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
