import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_colors.dart';
import '../../widgets/custom_timer_picker.dart';

import 'package:intl/intl.dart';

class MyRosterController extends GetxController {
  final selectedTabIndex = 0.obs;
  final selectedDuties = <String>[].obs;

  final showBreakTimeOptions = false.obs;
  final breakStartTime = TimeOfDay(hour: 8, minute: 50).obs;
  final breakEndTime = TimeOfDay(hour: 18, minute: 19).obs;

  @override
  void onInit() {
    super.onInit();
    _generateMonthlyRoster();
  }

  final List<Duty> duties = [
    Duty(
      id: '1',
      title: 'D T1-C-COORX 4202',
      time: 'PLN - 01:50-03:19',
      color: const Color(0xFFa18567),
    ),
    Duty(
      id: '2',
      title: 'D T1B-COORX 4202',
      time: 'PLN - 03:20-04:34',
      color: const Color(0xFF175503),
    ),
    Duty(
      id: '3',
      title: 'D T1B-COORX 960',
      time: 'PLN - 06:10-07:09',
      color: const Color(0xFF175503),
    ),
    Duty(
      id: '4',
      title: 'D T1-SVC-PC 5036',
      time: 'PLN - 09:15-11:14',
      color: const Color(0xFF19545c),
    ),
    Duty(
      id: '5',
      title: 'D T1- CKIN EC 2933',
      time: 'PLN - 11:40-13:00',
      color: const Color(0xFF369eac),
    ),
    Duty(
      id: '6',
      title: 'A T1-ARR-A PC 995',
      time: 'PLN - 14:30-14:59',
      color: const Color(0xFFa14a73),
    ),
    Duty(
      id: '7',
      title: 'D T1B-COORX 1992',
      time: 'PLN - 17:10-18:09',
      color: const Color(0xFF175503),
    ),
  ];

  void toggleDutySelection(String dutyId) {
    if (selectedDuties.contains(dutyId)) {
      selectedDuties.remove(dutyId);
    } else {
      selectedDuties.clear(); // Clear any previous selection
      selectedDuties.add(dutyId); // Add the new single selection
    }
  }

  void showAddOptionsBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Duty Time Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Time Information Rows
            _buildTimeInfoRow(
              'Add Break Time',
              isTap: true,
              onTap: () => _showBreakTimeDialog(),
            ),
            const SizedBox(height: 12),
            _buildTimeInfoRow('Start Time', value: '08:50'),
            const SizedBox(height: 12),
            _buildTimeInfoRow('End Time', value: '18:19'),
            const SizedBox(height: 12),
            _buildTimeInfoRow('Total Duty Time', value: '7h 31min'),
            const SizedBox(height: 20),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.colorPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Get.back(),
                child: Text(
                  'CLOSE',
                  style: TextStyle(color: AppColors.colorPrimary, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfoRow(
    String label, {
    String? value,
    bool isTap = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isTap ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            if (value != null)
              Text(
                value,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            if (isTap)
              Icon(
                Icons.add_circle_outline,
                color: AppColors.colorPrimary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  // Similar methods for _showStartTimeDialog, _showEndTimeDialog, _showTotalTimeDialog

  void showMarkDutyBottomSheet() {
    if (selectedDuties.isEmpty) return;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Mark Selected Duties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildMarkOption(Icons.sick, 'Sick Leave'),
            _buildMarkOption(Icons.calendar_today, 'Day Off'),
            _buildMarkOption(Icons.swap_horiz, 'Swap Request'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorPrimary,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => Get.back(),
              child: const Text(
                'CONFIRM',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildMarkOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.colorPrimary),
      title: Text(title),
      onTap: () {
        Get.back();
        Get.snackbar(
          'Success',
          'Duties marked as $title',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }

  void _showBreakTimeDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Add Break Time',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Current Break Time Display
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimeInfoRow('Start Time', value: '08:50'),
                  const SizedBox(height: 12),
                  _buildTimeInfoRow('End Time', value: '18:19'),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: TimePickerField(
                      label: 'Start Time',
                      initialTime: breakStartTime.value,
                      onTimeChanged: (time) => breakStartTime.value = time,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TimePickerField(
                      label: 'End Time',
                      initialTime: breakEndTime.value,
                      onTimeChanged: (time) => breakEndTime.value = time,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorPrimary,
                minimumSize: const Size(120, 48),
              ),
              onPressed: () {
                // Save break time logic here
                Get.back();
              },
              child: const Text('SAVE', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // Monthly roster generation

  final currentMonth = DateTime.now().obs;
  final currentWeek = 32.obs; // Initialize with current week
  final weeksInMonth = <Week>[].obs;

  void _generateMonthlyRoster() {
    weeksInMonth.clear();

    // Get first and last day of month
    final firstDay = DateTime(
      currentMonth.value.year,
      currentMonth.value.month,
      1,
    );
    final lastDay = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
      0,
    );

    // Generate weeks
    DateTime currentDay = firstDay;
    while (currentDay.isBefore(lastDay)) {
      final weekStart = currentDay;
      final weekEnd = currentDay.add(const Duration(days: 6));

      weeksInMonth.add(
        Week(
          number: _calculateWeekNumber(weekStart),
          startDate: weekStart,
          endDate: weekEnd,
          days: _generateDaysForWeek(weekStart, weekEnd),
        ),
      );

      currentDay = currentDay.add(const Duration(days: 7));
    }

    // Update current week
    currentWeek.value = _calculateWeekNumber(DateTime.now());
  }

  int _calculateWeekNumber(DateTime date) {
    // Simple implementation - adjust as needed
    return ((date.day - 1) ~/ 7) + 1;
  }

  List<Day> _generateDaysForWeek(DateTime start, DateTime end) {
    final days = <Day>[];
    DateTime current = start;

    while (current.isBefore(end.add(const Duration(days: 1)))) {
      days.add(Day(date: current, duties: _generateDutiesForDay(current)));
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  List<Duty> _generateDutiesForDay(DateTime date) {
    // Your implementation from earlier
    // Return list of duties for the given date
    return []; // Replace with actual data
  }

  void previousMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
      1,
    );
    _generateMonthlyRoster();
  }

  void nextMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
      1,
    );
    _generateMonthlyRoster();
  }
}

class Duty {
  final String id;
  final String title;
  final String time;
  final Color color;

  Duty({
    required this.id,
    required this.title,
    required this.time,
    required this.color,
  });
}

class Week {
  final int number;
  final DateTime startDate;
  final DateTime endDate;
  final List<Day> days;

  Week({
    required this.number,
    required this.startDate,
    required this.endDate,
    required this.days,
  });
}

class Day {
  final DateTime date;
  final List<Duty> duties;

  Day({required this.date, required this.duties});
}
