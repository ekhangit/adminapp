import 'package:dhs_app/models/staff_data_model.dart';
import 'package:dhs_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:dhs_app/screens/flightcomm/form/widget/multi_select_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant.dart';
import '../../../controllers/flight/chat_controller.dart';
import '../../../widgets/custom_loader.dart';

class StaffForm extends StatefulWidget {
  const StaffForm({super.key});

  @override
  State<StaffForm> createState() => _StaffFormState();
}

class _StaffFormState extends State<StaffForm> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<ChatController>();
    // Fetch staff data when the form is opened
    controller.fetchStaffData(controller.argument as int);
  }

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
        child: Obx(() {
          final flightDetail = controller.flightDetail.value;
          final staffData = controller.staffData.value;

          if (flightDetail == null) {
            return const CustomLoader();
          }

          if (staffData == null) {
            return const CustomLoader();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flight Info Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First line: Flight No and Airport
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem(
                          flightDetail.basicDetails.flightInfo,
                        ),
                        _buildInfoItem(
                          'Airport:${flightDetail.departureAirport.iataCode}|${flightDetail.arrivalAirport.iataCode}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Second line: STD, ETD, ATD
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem(
                          'STD:${_formatTime(flightDetail.basicDetails.std)}',
                        ),
                        _buildInfoItem(
                          'ETD:${_formatTime(flightDetail.basicDetails.etd)}',
                        ),
                        _buildInfoItem(
                          'ATD:${_formatTime(flightDetail.basicDetails.atd)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Generate service sections dynamically from flight_services in staffData
              ...staffData.flightServices.map((service) {
                return Column(
                  children: [
                    _buildServiceSection(
                      service: service,
                      airportName: staffData.airportInfo.name,
                      controller: controller,
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }),

              // If no flight services, show a message
              if (staffData.flightServices.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No services available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildServiceSection({
    required FlightService service,
    required String airportName,
    required ChatController controller,
  }) {
    final selectedEmployees = <Employee>[].obs;
    final employeeTimesMap = <int, Map<String, TextEditingController>>{}.obs;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service header with time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Text(
                  _formatTimeRange(service.startTime, service.endTime),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  service.abbr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Staff Multi-Selection
          Padding(
            padding: const EdgeInsets.all(12),
            child: GenericMultiSelectDropdown<Employee>(
              label: "Select Employees",
              options: service.availableEmployees,
              selectedItems: selectedEmployees,
              hint: "Select employees",
              displayText: (employee) => '$airportName - ${employee.name}',
              filterCondition: (employee, term) =>
                  employee.name.toLowerCase().contains(term.toLowerCase()),
            ),
          ),

          // Show time fields for selected employees
          Obx(() {
            if (selectedEmployees.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: selectedEmployees.map((employee) {
                  // Initialize controllers for this employee if not exists
                  if (!employeeTimesMap.containsKey(employee.id)) {
                    employeeTimesMap[employee.id] = {
                      'sla': TextEditingController(),
                      'pln': TextEditingController(),
                      'act': TextEditingController(),
                    };
                  }

                  return _buildEmployeeTimeFields(
                    employee: employee,
                    service: service,
                    airportName: airportName,
                    controllers: employeeTimesMap[employee.id]!,
                    onRemove: () {
                      selectedEmployees.remove(employee);
                      employeeTimesMap.remove(employee.id);
                    },
                  );
                }).toList(),
              ),
            );
          }),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildEmployeeTimeFields({
    required Employee employee,
    required FlightService service,
    required String airportName,
    required Map<String, TextEditingController> controllers,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with service badge and employee name
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                // Service badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    service.abbr,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Employee name
                Expanded(
                  child: Text(
                    '$airportName - ${employee.name}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Remove button
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.red),
                  onPressed: onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Time fields section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // SLA
                _buildMobileTimeField(
                  label: "SLA",
                  controller: controllers['sla']!,
                  labelColor: Colors.orange,
                ),
                const SizedBox(height: 12),

                // PLN
                _buildMobileTimeField(
                  label: "PLN",
                  controller: controllers['pln']!,
                  labelColor: Colors.green,
                ),
                const SizedBox(height: 12),

                // ACT
                _buildMobileTimeField(
                  label: "ACT",
                  controller: controllers['act']!,
                  labelColor: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTimeField({
    required String label,
    required TextEditingController controller,
    required Color labelColor,
  }) {
    return Row(
      children: [
        // Label badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: labelColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Time input field
        Expanded(
          child: GestureDetector(
            onTap: () => _pickTime(controller),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      controller.text.isEmpty ? '2026-01-12 00:00' : controller.text,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickTime(TextEditingController controller) async {
    // First pick date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      // Then pick time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Format as: 2026-01-12 04:40
        final formattedDate =
            '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
        final formattedTime =
            '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
        controller.text = '$formattedDate $formattedTime';
      }
    }
  }

  Widget _buildInfoItem(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  String _formatTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '';
    try {
      return formatFlightTime(dateTimeStr);
    } catch (e) {
      return '';
    }
  }

  String _formatTimeRange(String? startTime, String? endTime) {
    final start = _formatTime(startTime);
    final end = _formatTime(endTime);
    if (start.isEmpty && end.isEmpty) return '00:00 - 00:00';
    return '${start.isNotEmpty ? start : "00:00"} - ${end.isNotEmpty ? end : "00:00"}';
  }
}
