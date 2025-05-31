import 'package:aviation_app/controllers/flight/chat_controller.dart';
import 'package:aviation_app/screens/flightcomm/form/widget/form_widgets.dart';
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
              showLabel: false,
              controller: controller.lofoController,
            ),
            const SizedBox(height: 12),

            singleField(
              "LOFO RMKS",
              showLabel: false,
              maxLines: 3,
              controller: controller.lofoRemarksController,
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    child: timerField(
                      label: "START TIME",
                      showHint: false,
                      controller: controller.startTimeController,
                      onTap: () => controller.pickTime(true),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: timerField(
                      label: "END TIME",
                      showHint: false,
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
              child: Row(
                children: [
                  Expanded(
                    child: singleField(
                      "MHB AHL",
                      showLabel: false,
                      controller: controller.mhbAHLController,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: singleField(
                      "OHD",
                      showLabel: false,
                      controller: controller.ohdController,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: singleField(
                      "DPR",
                      showLabel: false,
                      controller: controller.dprController,
                    ),
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
