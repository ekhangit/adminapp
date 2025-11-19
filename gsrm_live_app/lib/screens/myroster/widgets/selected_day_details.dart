import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../controllers/myroster/my_roster_controller.dart';
import 'duty_card.dart';

class SelectedDayDetails extends StatelessWidget {
  final List<DateTime> selectedDays;
  final MyRosterController controller;

  const SelectedDayDetails({
    super.key,
    required this.selectedDays,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Date Header
          _buildDateHeader(selectedDays),
          const SizedBox(height: 12),
          // Time Info Section (similar to today roster)
          _buildTimeInfoSection(selectedDays, controller),
          const SizedBox(height: 16),
          // Duties Display
          _buildDutiesSection(selectedDays, controller),
        ],
      ),
    );
  }

  Widget _buildDateHeader(List<DateTime> selectedDays) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple.shade600, Colors.deepPurple.shade700],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedDays.length == 1 ? 'Selected Day' : 'Selected Days',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  selectedDays.length == 1
                      ? DateFormat(
                        'EEEE, MMMM dd, yyyy',
                      ).format(selectedDays.first)
                      : selectedDays
                          .map((date) => DateFormat('MMM dd').format(date))
                          .join(' • '),
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfoSection(
    List<DateTime> selectedDays,
    MyRosterController controller,
  ) {
    // Calculate summary info for all selected days
    String startTime = '';
    String endTime = '';
    String totalDutyTime = '';
    String breakTime = '';

    if (selectedDays.isNotEmpty) {
      if (selectedDays.length == 1) {
        // Single day - show specific times
        for (final week in controller.weeksInMonth) {
          for (final day in week.days) {
            if (day.date.year == selectedDays.first.year &&
                day.date.month == selectedDays.first.month &&
                day.date.day == selectedDays.first.day) {
              if (day.startTime != null) {
                startTime = day.startTime!.split(' ').last;
              }
              if (day.endTime != null) {
                endTime = day.endTime!.split(' ').last;
              }
              totalDutyTime = day.totalDutyHours;
              if (day.breakHours > 0 || day.breakMinutes > 0) {
                breakTime = '${day.breakHours}h ${day.breakMinutes}m';
              }
              break;
            }
          }
        }
      } else {
        // Multiple days - show summary
        int totalMinutes = 0;
        double totalBreakHours = 0.0;
        int totalBreakMinutes = 0;
        DateTime? earliestStart;
        DateTime? latestEnd;

        for (final selectedDate in selectedDays) {
          for (final week in controller.weeksInMonth) {
            for (final day in week.days) {
              if (day.date.year == selectedDate.year &&
                  day.date.month == selectedDate.month &&
                  day.date.day == selectedDate.day) {
                totalMinutes += day.totalDutyMinutes;
                totalBreakHours += day.breakHours;
                totalBreakMinutes += day.breakMinutes;

                if (day.startTime != null) {
                  final startDateTime = DateTime.parse(day.startTime!);
                  if (earliestStart == null ||
                      startDateTime.isBefore(earliestStart)) {
                    earliestStart = startDateTime;
                  }
                }

                if (day.endTime != null) {
                  final endDateTime = DateTime.parse(day.endTime!);
                  if (latestEnd == null || endDateTime.isAfter(latestEnd)) {
                    latestEnd = endDateTime;
                  }
                }
                break;
              }
            }
          }
        }

        // if (earliestStart != null) {
        //   startTime =
        //       '${earliestStart.hour.toString().padLeft(2, '0')}:${earliestStart.minute.toString().padLeft(2, '0')}';
        // }
        // if (latestEnd != null) {
        //   endTime =
        //       '${latestEnd.hour.toString().padLeft(2, '0')}:${latestEnd.minute.toString().padLeft(2, '0')}';
        // }

        final totalHours = totalMinutes ~/ 60;
        final remainingMinutes = totalMinutes % 60;
        totalDutyTime = '${totalHours}h ${remainingMinutes}m';

        if (totalBreakHours > 0 || totalBreakMinutes > 0) {
          breakTime = '${totalBreakHours}h ${totalBreakMinutes}m';
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTimeInfoItem(
                  selectedDays.length > 1 ? 'Total Break' : 'Add Break Time',
                  breakTime,
                  selectedDays.length > 1 ? null : Icons.add_circle_outline,
                  Colors.deepPurple,
                  isTappable: selectedDays.length == 1,
                  onTap:
                      selectedDays.length == 1
                          ? () => controller.showAddBreakTimeBottomSheet()
                          : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimeInfoItem(
                  selectedDays.length > 1 ? 'Earliest Start' : 'Start Time',
                  controller.formatTimeDisplay(startTime),
                  null,
                  Colors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTimeInfoItem(
                  selectedDays.length > 1 ? 'Latest End' : 'End Time',
                  controller.formatTimeDisplay(endTime),
                  null,
                  Colors.indigo,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimeInfoItem(
                  selectedDays.length > 1
                      ? 'Total Duty Time'
                      : 'Total duty Time',
                  totalDutyTime,
                  null,
                  Colors.amber[700]!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfoItem(
    String label,
    String value,
    IconData? icon,
    Color color, {
    bool isTappable = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isTappable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  if (value.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDutiesSection(
    List<DateTime> selectedDays,
    MyRosterController controller,
  ) {
    // Get duties for all selected days
    List<Widget> dutyCards = [];

    for (final date in selectedDays) {
      final duties = controller.getDutiesForDay(date);
      dutyCards.addAll(
        duties.map((duty) => DutyCard(duty: duty, controller: controller)),
      );
    }

    if (dutyCards.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'No duties assigned for selected day(s)',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dutyCards,
    );
  }
}
