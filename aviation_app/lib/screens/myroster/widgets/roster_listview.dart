import 'package:aviation_app/screens/myroster/widgets/selected_day_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/myroster/my_roster_controller.dart';
import 'package:intl/intl.dart';

import '../../../models/roster_models.dart';

class RosterListview extends StatelessWidget {
  final List<Week> weeksInMonth;
  const RosterListview({super.key, required this.weeksInMonth});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyRosterController>();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: weeksInMonth.length,
      itemBuilder: (context, weekIndex) {
        final week = weeksInMonth[weekIndex];
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Week header with expand/collapse button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Week ${week.number}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        // Expand/Collapse button
                        Obx(() {
                          final isExpanded = controller.isWeekExpanded(
                            week.number,
                          );
                          final hasAssignedDuties = week.days.any(
                            (day) => day.duties.isNotEmpty,
                          );

                          if (!hasAssignedDuties) return const SizedBox();

                          return GestureDetector(
                            onTap:
                                () =>
                                    controller.toggleWeekExpansion(week.number),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isExpanded
                                        ? Colors.deepPurple.shade50
                                        : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      isExpanded
                                          ? Colors.deepPurple.shade200
                                          : Colors.blue.shade200,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    size: 14,
                                    color:
                                        isExpanded
                                            ? Colors.deepPurple.shade600
                                            : Colors.blue.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isExpanded ? 'Collapse' : 'Expand All',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          isExpanded
                                              ? Colors.deepPurple.shade600
                                              : Colors.blue.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Horizontal scrollable day cards
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: week.days.length,
                      itemBuilder: (context, dayIndex) {
                        final day = week.days[dayIndex];
                        final isWeekend =
                            day.date.weekday == DateTime.saturday ||
                            day.date.weekday == DateTime.sunday;

                        return Obx(() {
                          final isSelected = controller.isDaySelected(day.date);
                          final isDisabled =
                              controller.selectedDays.isNotEmpty && !isSelected;

                          return Container(
                            width: 140,
                            margin: EdgeInsets.only(
                              left: dayIndex == 0 ? 0 : 4,
                              right: dayIndex == week.days.length - 1 ? 0 : 4,
                            ),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side:
                                    isSelected
                                        ? const BorderSide(
                                          color: Colors.deepPurple,
                                          width: 2,
                                        )
                                        : BorderSide.none,
                              ),
                              color:
                                  isDisabled
                                      ? Colors.blue.shade50
                                      : (isWeekend
                                          ? Colors.grey[50]
                                          : Colors.white),
                              child: InkWell(
                                onTap:
                                    day.duties.isNotEmpty
                                        ? () => controller.selectDay(day.date)
                                        : null,
                                borderRadius: BorderRadius.circular(12),
                                child: Opacity(
                                  opacity: isDisabled ? 0.6 : 1.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Date header
                                        Column(
                                          children: [
                                            Text(
                                              DateFormat(
                                                'yyyy-MM-dd',
                                              ).format(day.date),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    isDisabled
                                                        ? Colors.grey[500]
                                                        : Colors.grey[700],
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              DateFormat(
                                                'EEE',
                                              ).format(day.date),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    isDisabled
                                                        ? Colors.grey[500]
                                                        : (isWeekend
                                                            ? Colors.blue
                                                            : Colors.black87),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),

                                        // Duty details or unassigned/day off status
                                        if (day.duties.isEmpty)
                                          Expanded(
                                            child: Center(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      day.isDayOff
                                                          ? const Color(
                                                            0xFF4CAF50,
                                                          ) // Green for day off
                                                          : const Color(
                                                            0xFFf8e500,
                                                          ), // Yellow for unassigned
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  day.isDayOff
                                                      ? 'Day Off'
                                                      : 'Unassigned',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        day.isDayOff
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        else
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // Start Time
                                                if (day.startTime != null)
                                                  _buildDutyInfo(
                                                    'Start Time ${controller.formatTimeDisplay(day.startTime!.split(' ').last)}',
                                                    Colors.green,
                                                  ),
                                                // End Time
                                                if (day.endTime != null)
                                                  _buildDutyInfo(
                                                    'End Time ${controller.formatTimeDisplay(day.endTime!.split(' ').last)}',
                                                    Colors.blue,
                                                  ),
                                                // Break Time
                                                if (day.breakMinutes > 0)
                                                  _buildDutyInfo(
                                                    'Break ${day.breakMinutes}m',
                                                    const Color(0xFF1a47ab),
                                                  ),
                                                // Duty Period
                                                if (day
                                                    .totalPeriodHours
                                                    .isNotEmpty)
                                                  _buildDutyInfo(
                                                    'Duty Period ${day.totalPeriodHours}hr',
                                                    Colors.orange,
                                                  ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),

                  // Expanded view showing all week duties
                  // Obx(() {
                  //   if (!controller.isWeekExpanded(week.number)) {
                  //     return const SizedBox();
                  //   }

                  //   return Container(
                  //     margin: const EdgeInsets.only(top: 12),
                  //     child: _buildExpandedWeekView(week),
                  //   );
                  // }),
                ],
              ),
            ),

            // Show selected day details if it belongs to this week
            _buildSelectedDayDetailsNew(week),

            // Add divider after each week
            if (weekIndex < controller.weeksInMonth.length - 1)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: const Divider(thickness: 2, color: Colors.grey),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSelectedDayDetailsNew(Week week) {
    final controller = Get.find<MyRosterController>();
    return Obx(() {
      if (controller.selectedDays.isEmpty) return const SizedBox();

      // Get all selected days that belong to this week
      final weekSelectedDays =
          controller.selectedDays
              .where(
                (selectedDay) => week.days.any(
                  (day) =>
                      day.date.day == selectedDay.day &&
                      day.date.month == selectedDay.month &&
                      day.date.year == selectedDay.year,
                ),
              )
              .toList();

      if (weekSelectedDays.isEmpty) return const SizedBox();

      return Column(
        children: [
          for (int i = 0; i < weekSelectedDays.length; i++) ...[
            SelectedDayDetails(
              selectedDays: [weekSelectedDays[i]], // Pass individual day
              controller: controller,
            ),
            if (i < weekSelectedDays.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  thickness: 1,
                  color: Colors.grey.shade300,
                  indent: 16,
                  endIndent: 16,
                ),
              ),
          ],
        ],
      );
    });
  }

  Widget _buildExpandedWeekView(Week week) {
    final controller = Get.find<MyRosterController>();

    // Get all days that have duties
    final daysWithDuties =
        week.days.where((day) => day.duties.isNotEmpty).toList();

    if (daysWithDuties.isEmpty) return const SizedBox();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header for expanded view
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.view_list,
                  size: 16,
                  color: Colors.deepPurple.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Week ${week.number} - All Assigned Duties',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
              ],
            ),
          ),

          // List of all days with duties
          for (int i = 0; i < daysWithDuties.length; i++) ...[
            SelectedDayDetails(
              selectedDays: [daysWithDuties[i].date],
              controller: controller,
            ),
            if (i < daysWithDuties.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Divider(thickness: 1, color: Colors.grey.shade300),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildDutyInfo(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
