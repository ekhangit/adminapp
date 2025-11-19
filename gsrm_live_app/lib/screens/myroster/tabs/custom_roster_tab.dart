import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/myroster/my_roster_controller.dart'
    show MyRosterController;
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_loader.dart';
import '../widgets/roster_listview.dart';

class CustomRosterTab extends StatelessWidget {
  const CustomRosterTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyRosterController>();

    return Obx(
      () => Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Date Range Preview
              Container(
                margin: EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            'From',
                            controller.customFromDate.value,
                            () => _selectFromDate(context, controller),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDateField(
                            'To',
                            controller.customToDate.value,
                            () => _selectToDate(context, controller),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // if (controller.isCustomDateRangeSelected.value)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              controller.customFromDate.value != null &&
                                      controller.customToDate.value != null
                                  ? AppColors.colorPrimary
                                  : Colors.grey[400],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed:
                            controller.customFromDate.value != null &&
                                    controller.customToDate.value != null
                                ? () {
                                  controller.isCustomDateRangeSelected.value =
                                      true;
                                  controller.loadCustomRosterFromAPI();
                                }
                                : null,
                        child: const Text(
                          'SEARCH ROSTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // RosterListview(weeksInMonth: controller.customRosterWeeks),

              // Roster List
              controller.isCustomDateRangeSelected.value &&
                      controller.customRosterWeeks.isNotEmpty
                  ? RosterListview(weeksInMonth: controller.customRosterWeeks)
                  : _buildEmptyState(controller),
            ],
          ),

          if (controller.customRosterWeeks.isNotEmpty)
            if (controller.isLoadingCustomRoster.value)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomLoader(),
              ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null
                        ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
                        : 'Select date',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: date != null ? Colors.grey[800] : Colors.grey[500],
                      fontWeight:
                          date != null ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[400]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectFromDate(
    BuildContext context,
    MyRosterController controller,
  ) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: controller.customFromDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      // If toDate is before the new fromDate, adjust toDate
      if (controller.customToDate.value != null &&
          controller.customToDate.value!.isBefore(selectedDate)) {
        controller.customToDate.value = selectedDate.add(
          const Duration(days: 1),
        );
      }
      controller.customFromDate.value = selectedDate;
    }
  }

  Future<void> _selectToDate(
    BuildContext context,
    MyRosterController controller,
  ) async {
    final initialDate =
        controller.customToDate.value ??
        controller.customFromDate.value?.add(const Duration(days: 1)) ??
        DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: controller.customFromDate.value ?? DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      // Ensure toDate is not before fromDate
      if (controller.customFromDate.value != null &&
          selectedDate.isBefore(controller.customFromDate.value!)) {
        Get.snackbar('Error', 'To date cannot be before from date');
        return;
      }
      controller.customToDate.value = selectedDate;
    }
  }

  Widget _buildEmptyState(MyRosterController controller) {
    return Obx(
      () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Select Date Range',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a from and to date to view your roster',
              style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (controller.customRosterWeeks.isEmpty &&
                controller.isCustomDateRangeSelected.value)
              const Center(child: CustomLoader()),
          ],
        ),
      ),
    );
  }
}
