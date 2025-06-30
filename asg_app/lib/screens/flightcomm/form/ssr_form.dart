import 'package:asg_app/screens/flightcomm/form/widget/multi_select_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/flight_info_controller.dart';
import '../../../utils/app_colors.dart';

class SSRForm extends StatelessWidget {
  const SSRForm({super.key});

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
            MultiSelectDropdown(
              label: "Select SSR",
              options: controller.getSSROptions,
              selectedItems: controller.selectedSSR,
            ),

            const SizedBox(height: 16),

            Obx(
              () => Column(
                children:
                    controller.selectedSSR.map((ssr) {
                      // Initialize controller if not already created
                      controller.ssrInputs.putIfAbsent(
                        ssr,
                        () => TextEditingController(),
                      );

                      final ssrController = controller.ssrInputs[ssr]!;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextField(
                          controller: ssrController,
                          decoration: InputDecoration(
                            labelText: ssr,
                            hintText: "Enter details for $ssr",
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 0.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppColors.colorPrimary,
                                width: 1.5,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppColors.colorWarning,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
