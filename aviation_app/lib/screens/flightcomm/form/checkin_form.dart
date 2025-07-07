import 'package:aviation_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';
import '../../../utils/app_colors.dart';

class CheckInForm extends StatelessWidget {
  const CheckInForm({super.key});

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
            // Row(
            //   children: [
            //     Expanded(
            //       child: MultiSelectDropdown(
            //         label: "Flight No",
            //         options: controller.flightOptions,
            //         selectedItems: controller.selectedFlight,
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     Expanded(child: singleField("Callsign")),
            //   ],
            // ),
            // const SizedBox(height: 12),
            // Row(
            //   children: [
            //     Expanded(child: singleField("Date")),

            //     const SizedBox(width: 12),
            //     Expanded(
            //       child: MultiSelectDropdown(
            //         label: "A/C Type",
            //         options: controller.flightOptions,
            //         selectedItems: controller.selectedFlight,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 12),

            // Row(
            //   children: [
            //     Expanded(
            //       child: MultiSelectDropdown(
            //         label: "A/C Regin",
            //         options: controller.flightOptions,
            //         selectedItems: controller.selectedFlight,
            //       ),
            //     ),

            //     const SizedBox(width: 12),

            //     Expanded(child: singleField("Gate")),
            //   ],
            // ),
            const SizedBox(height: 12),
            formRow("Stand", "Baggage Belt"),

            const SizedBox(height: 24),

            // 🔹 Title Section
            const Text(
              "Staff Info",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.colorPrimary,
              ),
            ),
            const SizedBox(height: 16),

            singleField("Select or Add CKIN", showLabel: false),
            const SizedBox(height: 12),

            singleField("Select or Add Gate", showLabel: false),
            const SizedBox(height: 12),

            singleField("Select or Add Gate SPVIR", showLabel: false),
            const SizedBox(height: 12),
            singleField("SPVIR RMKS", maxLines: 2),

            const SizedBox(height: 24),

            // 🔹 Title Section
            const Text(
              "Flight Breifing",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.colorPrimary,
              ),
            ),
            const SizedBox(height: 16),
            singleField("SPECIALS"),
            const SizedBox(height: 12),
            singleField("BOOKING STATUS"),
            const SizedBox(height: 12),
            singleField("SCHDULE INFO"),
            const SizedBox(height: 12),
            singleField("DOCS CHECK"),
            const SizedBox(height: 12),
            singleField("RAMO (SPECIAL)"),
            const SizedBox(height: 12),
            singleField("OTHERS"),
          ],
        ),
      ),
    );
  }
}
