import 'package:dhs_app/controllers/flight/chat_controller.dart';
import 'package:dhs_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ARRForm extends StatelessWidget {
  const ARRForm({super.key});

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
            singleField(
              "LOFO",
              showLabel: true,
              controller: controller.lofoController,
            ),
            const SizedBox(height: 12),

            singleField(
              "LOFO RMKS",
              showLabel: true,
              maxLines: 3,
              controller: controller.lofoRemarksController,
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    child: timerField2ForChat(
                      label: "START TIME",
                      controller: controller.startTimeController,
                      onTap: () => controller.pickTime(true),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: timerField2ForChat(
                      label: "END TIME",
                      controller: controller.endTimeController,
                      onTap: () => controller.pickTime(false),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MHB parent label
                  Text(
                    "MHB",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  singleField(
                    "AHL",
                    showLabel: true,
                    controller: controller.mhbAHLController,
                  ),
                  const SizedBox(height: 12),
                  singleField(
                    "OHD",
                    showLabel: true,
                    controller: controller.ohdController,
                  ),
                  const SizedBox(height: 12),
                  singleField(
                    "DPR",
                    showLabel: true,
                    controller: controller.dprController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
