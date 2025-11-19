import 'package:gsrm_live_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:gsrm_live_app/screens/flightcomm/form/widget/multi_select_dropdown.dart';
// import 'package:sp_app/screens/flightcomm/form/widget/single_selected_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant.dart';
import '../../../controllers/flight/chat_controller.dart';
// import '../../../controllers/flight/flight_info_controller.dart';
import '../../../controllers/flight/flight_info_controller.dart';
import '../../../utils/app_colors.dart';

class TRCForm extends StatelessWidget {
  const TRCForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final flightInfoController = Get.find<FlightInfoController>();

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
                    controller.flightDetail.value?.aircraftType?.icao ?? '',
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
              "TRC Info",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.colorPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 New Fields
            formRow("TRC Name", "Mobile No"),
            const SizedBox(height: 12),
            singleField("TRC RMKS", maxLines: 2),

            const SizedBox(height: 24),

            // 🔹 Title Section
            const Text(
              "A/C Data",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.colorPrimary,
              ),
            ),
            const SizedBox(height: 12),
            formRow("CREW", "PANTRY"),
            const SizedBox(height: 12),
            singleField("CAPTAIN"),
            const SizedBox(height: 12),
            formRow("DOW", "DOI"),
            const SizedBox(height: 12),
            formRow("MTOW", "RTOW"),

            const SizedBox(height: 24),

            // 🔹 Title Section
            const Text(
              "Fuel Data",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.colorPrimary,
              ),
            ),
            const SizedBox(height: 12),
            formRow("TAXI+APU", "BLOCK FUEL"),
            const SizedBox(height: 12),
            formRow("TRIP", "E.E.T"),

            const SizedBox(height: 12),
            formRow("TAKE OFF", "UPLIFTED"),
            const SizedBox(height: 12),
            singleField("ALTN"),
            const SizedBox(height: 24),

            const Text(
              "F.O.D",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.colorPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: singleField("Before Arrival")),
                const SizedBox(width: 12),
                Expanded(child: singleField("Before Departure")),
              ],
            ),
            const SizedBox(height: 12),
            singleField("After Departure"),

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
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: singleField("DEST", disbaleHint: true)),
                const SizedBox(width: 12),
                Expanded(
                  child: MultiSelectDropdown(
                    label: "POS",
                    options: controller.posOptions,
                    selectedItems: controller.selectedPos,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MultiSelectDropdown(
                    label: "L/R",
                    options: controller.posOptions,
                    selectedItems: controller.selectedLR,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: MultiSelectDropdown(
                    label: "ULD ID",
                    options: controller.posOptions,
                    selectedItems: controller.selectedULD,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: singleField("OWNER", disbaleHint: true)),
                const SizedBox(width: 12),
                Expanded(child: singleField("PCS", disbaleHint: true)),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: singleField("WT", disbaleHint: true)),
                const SizedBox(width: 12),
                Expanded(
                  child: MultiSelectDropdown(
                    label: "V/R",
                    options: controller.posOptions,
                    selectedItems: controller.selectedVR,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: singleField("NOTOC", disbaleHint: true)),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: singleField("DETAILS", disbaleHint: true)),
                const SizedBox(width: 12),
                Expanded(child: SizedBox()),
                const SizedBox(width: 12),
                Expanded(child: SizedBox()),
              ],
            ),

            const SizedBox(height: 12),
            singleField("Remove Position", disbaleHint: true),
          ],
        ),
      ),
    );
  }
}
