import 'package:asg_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:asg_app/screens/flightcomm/form/widget/multi_select_dropdown.dart';
import 'package:asg_app/screens/flightcomm/form/widget/single_selected_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';
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
                  child: FlightNoSelectDropdown(
                    label: "Flight Info",
                    options: flightInfoController.getFlightNo,
                    selectedItem: flightInfoController.selectedFlightInfoTRC,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: singleField("Callsign")),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: singleField("Date")),

                const SizedBox(width: 12),
                Expanded(
                  child: AircraftTypeSelectDropdown(
                    label: "A/C Type",
                    options: flightInfoController.aircraftTypes,
                    selectedItem: flightInfoController.selectedAircraft,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AircraftRegSelectDropdown(
                    label: "A/C Regin",
                    options: flightInfoController.aircraftReg,
                    selectedItem: flightInfoController.selectedAircraftReg,
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(child: singleField("Gate")),
              ],
            ),
            const SizedBox(height: 12),
            formRow("Stand", "Baggage Belt"),

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
            singleField("Before Arrival"),
            const SizedBox(height: 12),
            singleField("Before Departure"),
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

            const Text(
              "PAX : 98 + 0 INF + 0 JMP",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
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
