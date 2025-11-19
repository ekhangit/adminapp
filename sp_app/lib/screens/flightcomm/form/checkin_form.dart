import 'package:sp_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant.dart';
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
            Row(
              children: [
                Expanded(
                  child: singleLabel(
                    "Flight Info",
                    controller.flightDetail.value?.basicDetails.flightInfo ??
                        '',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: singleLabel(
                    "Callsign",
                    controller.flightDetail.value?.basicDetails.callSign ?? '',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: singleLabel(
                    "Date",
                    formatDate(
                      controller.flightDetail.value?.basicDetails.date ?? '--',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: singleLabel(
                    "A/C Type",
                    controller.flightDetail.value?.aircraftType!.icao ?? '',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: singleLabel(
                    "A/C Regin",
                    controller.flightDetail.value?.aircraft?.name ?? '',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: singleLabel(
                    "Gate",
                    controller.flightDetail.value?.basicDetails.gate ?? '',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: singleLabel(
                    "Stand",
                    controller.flightDetail.value?.basicDetails.pos ?? '',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: singleLabel(
                    "Baggage Belt",
                    controller.flightDetail.value?.basicDetails.beggageBelt ??
                        '',
                  ),
                ),
              ],
            ),

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

            singleField("Select or Add Gate SPVR", showLabel: false),
            const SizedBox(height: 12),
            singleField("SPVR RMKS", maxLines: 2),

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
            singleField("RAMP (SPECIAL)"),
            const SizedBox(height: 12),
            singleField("OTHERS"),

            const SizedBox(height: 24),

            const Text(
              "Total Onboard",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.colorPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "PAX : ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      controller.flightDetail.value?.actualPax.totalPax
                              .toString() ??
                          "0",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "BAGS : ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "0 pcs",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
