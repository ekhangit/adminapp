import 'package:aviation_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:aviation_app/screens/flightcomm/form/widget/multi_select_dropdown.dart';
import 'package:aviation_app/screens/flightcomm/form/widget/single_selected_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/flight_info_controller.dart';
import '../../../models/airline_model.dart';
import '../../../models/flight_no_model.dart';

class OCCForm extends StatelessWidget {
  const OCCForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightInfoController>();

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
                  child: GestureDetector(
                    onTap: () => controller.pickFromDate(context),
                    child: AbsorbPointer(
                      child: singleField(
                        "From",
                        controller: controller.occFromController,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.pickToDate(context),
                    child: AbsorbPointer(
                      child: singleField(
                        "To",
                        controller: controller.occToController,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            GenericSelectDropdown<AirlineModel>(
              label: "Airline",
              options: controller.getAirline,
              selectedItem: controller.selectedAirlineOcc,
              displayText:
                  (item) => '${item.iata} | ${item.icao} | ${item.name}',
              filterCondition:
                  (item, term) => (item.name ?? '').toLowerCase().contains(
                    term.toLowerCase(),
                  ),
              isSelected: (a, b) => a.id == b.id,
            ),
            const SizedBox(height: 12),
            GenericMultiSelectDropdown<FlightNoModel>(
              label: "Flight Number",
              options: controller.getFlightNumbers,
              selectedItems: controller.selectedFlightNumberOCC,
              displayText: (item) => item.flightInfo,
              filterCondition:
                  (item, term) => item.flightInfo.toLowerCase().contains(
                    term.toLowerCase(),
                  ),
            ),
            const SizedBox(height: 12),
            GenericMultiSelectDropdown<AirportModel>(
              label: "Airport",
              options: controller.getAirport,
              selectedItems: controller.selectedAirportOCC,
              displayText: (item) => '${item.iata} | ${item.icao}',
              filterCondition:
                  (item, term) =>
                      item.iata!.toLowerCase().contains(term.toLowerCase()),
            ),
            const SizedBox(height: 12),
            // singleField('Type', showSelect: true),
            SingleSelectDropdown(
              label: 'Type',
              options: controller.typeOCC,
              selectedItem: controller.selectedTypeOCC,
              hint: 'Select Type',
            ),
            const SizedBox(height: 12),
            singleField(
              'Broadcast Message',
              maxLines: 5,
              controller: controller.boradcastMessageController,
            ),
          ],
        ),
      ),
    );
  }
}
