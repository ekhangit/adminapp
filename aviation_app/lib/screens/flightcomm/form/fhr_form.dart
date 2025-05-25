import 'package:aviation_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';

class FHRForm extends StatelessWidget {
  const FHRForm({super.key});

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
              "MISSED ARTG-5 EXPLANATION",
              maxLines: 3,
              controller: controller.missedArtg5ExplanationController,
            ),

            const SizedBox(height: 12),
            singleField(
              "DELAY EXPLANATION",
              maxLines: 3,

              controller: controller.delayExplanationController,
            ),

            const SizedBox(height: 12),
            singleField(
              "CHECK-IN/TKTG ISSUES",
              maxLines: 3,
              controller: controller.chkInTKGIssueController,
            ),

            const SizedBox(height: 12),
            singleField(
              "RAMP/CREWDISRUPTIVE PAX ETC",
              maxLines: 3,

              controller: controller.rampCrewDistruptivePaxController,
            ),

            const SizedBox(height: 12),
            singleField(
              "SAFETY/SECURITY/SYSTEM",
              maxLines: 3,
              controller: controller.safetySecuritySystemController,
            ),

            const SizedBox(height: 12),
            singleField(
              "OTHER",
              maxLines: 3,
              controller: controller.otherController,
            ),

            const SizedBox(height: 12),
            const SizedBox(height: 12),
            singleField(
              "INVOL DENIED BOARDING",
              maxLines: 3,
              controller: controller.involDeniedBoardingController,
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
