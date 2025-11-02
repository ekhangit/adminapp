import 'package:aviation_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:aviation_app/screens/flightcomm/form/widget/single_selected_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant.dart';
import '../../../controllers/flight/chat_controller.dart';
import '../../../controllers/flight/flight_info_controller.dart';
import '../../../utils/app_colors.dart';

class StaffForm extends StatelessWidget {
  const StaffForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final flightInfoController = Get.find<FlightInfoController>();

    // Get staff names for dropdown
    final staffNames = controller.staffList
        .map((staff) => staff.displayName ?? 'Unknown')
        .toList();

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
            // =9 Flight Details Section
            const Text(
              "Assign / edit Staff",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.colorPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Flight No
            singleLabel(
              "Flight No",
              controller.flightDetail.value?.basicDetails.flightInfo ?? 'N/A',
            ),
            const SizedBox(height: 12),

            // STD and ETD
            Row(
              children: [
                Expanded(
                  child: singleLabel(
                    "STD",
                    _formatDateTime(
                      controller.flightDetail.value?.basicDetails.std,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: singleLabel(
                    "ETD",
                    _formatDateTime(
                      controller.flightDetail.value?.basicDetails.etd,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ATD and Airport
            Row(
              children: [
                Expanded(
                  child: singleLabel(
                    "ATD",
                    _formatDateTime(
                      controller.flightDetail.value?.basicDetails.atd,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: singleLabel(
                    "Airport",
                    controller
                            .flightDetail.value?.departureAirport.iataCode ??
                        'N/A',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // =9 Staff Services Section
            const Text(
              "Staff Services",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.colorPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Generate service rows dynamically from SOD data
            ...controller.flightDetail.value?.sodData
                    .where((sod) => !sod.isEmpty)
                    .map((sod) {
                  return Column(
                    children: [
                      _buildServiceSection(
                        serviceAbbr: sod.serviceAbbr ?? 'Service',
                        startTime: sod.startTime,
                        endTime: sod.endTime,
                        staffNames: staffNames,
                        controller: controller,
                        onTimeChanged: (time) {
                          // Handle time change
                        },
                        onStaffSelected: (staff) {
                          // Handle staff selection
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }) ??
                [],

            // If no SOD data, show a default check-in service
            if (controller.flightDetail.value?.sodData.isEmpty ?? true)
              _buildServiceSection(
                serviceAbbr: 'CHECK IN',
                startTime: null,
                endTime: null,
                staffNames: staffNames,
                controller: controller,
                onTimeChanged: (time) {},
                onStaffSelected: (staff) {},
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection({
    required String serviceAbbr,
    required String? startTime,
    required String? endTime,
    required List<String> staffNames,
    required ChatController controller,
    required Function(String) onTimeChanged,
    required Function(String?) onStaffSelected,
  }) {
    final startTimeController = TextEditingController(text: startTime ?? '');
    final endTimeController = TextEditingController(text: endTime ?? '');
    final selectedStaff = ''.obs;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Name
          Text(
            serviceAbbr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.colorPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Time Selection Row
          Row(
            children: [
              Expanded(
                child: timerField(
                  label: "Start Time",
                  controller: startTimeController,
                  onTap: () => controller.pickTime(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: timerField(
                  label: "End Time",
                  controller: endTimeController,
                  onTap: () => controller.pickTime(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Staff Selection
          SingleSelectDropdown(
            label: "Select Employee",
            options: staffNames,
            selectedItem: selectedStaff,
            hint: "Select employee",
            onChanged: onStaffSelected,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return 'N/A';
    try {
      return formatFlightTime(dateTimeStr);
    } catch (e) {
      return dateTimeStr;
    }
  }
}
