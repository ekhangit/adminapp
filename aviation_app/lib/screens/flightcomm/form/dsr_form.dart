import 'package:aviation_app/controllers/flight/flight_info_controller.dart';
import 'package:aviation_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:aviation_app/screens/flightcomm/form/widget/single_selected_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DSRForm extends StatelessWidget {
  const DSRForm({super.key});

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
            FlightNoSelectDropdown(
              label: "Flight Info",
              options: controller.allFlightNos,
              selectedItem: controller.selectedFlightInfo,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => controller.pickDoiDate(context),
              child: AbsorbPointer(
                child: singleField("DOI", controller: controller.doiController),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => controller.pickDsrDate(context),
              child: AbsorbPointer(
                child: singleField(
                  "DATE",
                  controller: controller.dateController,
                ),
              ),
            ),
            const SizedBox(height: 12),
            singleField("PAX NAME", controller: controller.paxNameController),
            const SizedBox(height: 12),
            SingleSelectDropdown(
              label: 'Currency',
              options: controller.currencyList,
              selectedItem: controller.selectedCurrency,
              hint: 'Select Currency',
            ),
            const SizedBox(height: 12),
            singleField("AMOUNT", controller: controller.amountController),
            const SizedBox(height: 12),
            singleField("PNR", controller: controller.pnrController),
            const SizedBox(height: 12),
            SingleSelectDropdown(
              label: 'FOP',
              options: controller.fopList,
              selectedItem: controller.selectedFOP,
              hint: 'Select FOP',
            ),
            const SizedBox(height: 12),
            SingleSelectDropdown(
              label: 'SERVICE TYPE',
              options: controller.serviceTypeList,
              selectedItem: controller.selectedServiceType,
              hint: 'Select Service Type',
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
