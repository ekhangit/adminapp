import 'dart:developer';

import 'package:gsrm_live_app/controllers/myroster/custom_roster_mixin.dart';
import 'package:gsrm_live_app/controllers/myroster/monthly_roster_mixin.dart';
import 'package:gsrm_live_app/controllers/myroster/today_roster_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../models/roster_models.dart';
import '../../screens/flightcomm/form/widget/form_widgets.dart';
import '../../screens/myroster/widgets/add_break_time_bottom_sheet.dart';
import '../../screens/myroster/widgets/mark_duty_bottom_sheet.dart';
import '../../services/my_roster_service.dart';

class MyRosterController extends GetxController
    with TodayRosterMixin, MonthlyRosterMixin, CustomRosterMixin {
  final selectedTabIndex = 0.obs;
  final selectedDuties = <String>[].obs;
  var selectedDay = Rxn<DateTime>();
  final selectedDays = <DateTime>[].obs;

  final showBreakTimeOptions = false.obs;
  final breakStartTime = TimeOfDay(hour: 8, minute: 50).obs;
  final breakEndTime = TimeOfDay(hour: 18, minute: 19).obs;

  // Break time entries - support multiple breaks
  final breakTimeEntries = <BreakTimeEntry>[].obs;

  // Break time dialog fields
  final breakStartTimeString = ''.obs;
  final breakEndTimeString = ''.obs;

  // ACT time fields for marking duty
  final actStartTime = ''.obs;
  final actEndTime = ''.obs;
  final isActStartTimePopulated = false.obs;
  final isActEndTimePopulated = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('MyRosterController initialized');
    // Load today roster data
    loadTodayRosterFromAPI();

    // Load monthly roster from API or dummy data
    loadMonthlyRosterFromAPI();

    // Initialize with one empty break time entry
    breakTimeEntries.add(BreakTimeEntry(startTime: '', endTime: ''));
  }

  void toggleDutySelection(String dutyId) {
    // Find the duty to check if it has ACT time
    final duty = duties.firstWhere((d) => d.id.toString() == dutyId);

    // Don't allow selection if duty already has ACT time
    if (duty.actTime != null && duty.actTime!.isNotEmpty) {
      return; // Exit early, don't select
    }

    if (selectedDuties.contains(dutyId)) {
      selectedDuties.remove(dutyId);
    } else {
      selectedDuties.clear(); // Clear any previous selection
      selectedDuties.add(dutyId); // Add the new single selection
    }
  }

  void selectDay(DateTime? day) {
    if (day == null) return;

    // Check if any week is expanded
    final expandedWeekNumber =
        expandedWeeks.entries
            .where((entry) => entry.value == true)
            .map((entry) => entry.key)
            .firstOrNull;

    // Check if day is already selected
    final existingIndex = selectedDays.indexWhere(
      (selectedDay) =>
          selectedDay.day == day.day &&
          selectedDay.month == day.month &&
          selectedDay.year == day.year,
    );

    if (existingIndex != -1) {
      // Day is already selected, remove it
      selectedDays.removeAt(existingIndex);
      // Update selectedDay to the last selected day or null
      selectedDay.value = selectedDays.isNotEmpty ? selectedDays.last : null;

      // Update duties list for remaining selected days
      _updateDutiesForSelectedDays();
    } else {
      // Check if the new day is in the same week as already selected days
      bool isInSameWeek = false;
      if (selectedDays.isNotEmpty && expandedWeekNumber == null) {
        final selectedWeek = getWeekForDate(selectedDays.first);
        final newDayWeek = getWeekForDate(day);

        isInSameWeek =
            selectedWeek != null &&
            newDayWeek != null &&
            selectedWeek.number == newDayWeek.number;
      }

      // If no week is expanded and day is not in same week, clear previous selections
      if (expandedWeekNumber == null && !isInSameWeek) {
        selectedDays.clear();
      }

      selectedDays.add(day);
      selectedDay.value = day;

      // Populate duties list with duties from the selected day
      _updateDutiesForSelectedDays();
    }
  }

  void _updateDutiesForSelectedDays() {
    // Clear existing duties
    duties.clear();

    // Add duties from all selected days
    for (final selectedDate in selectedDays) {
      final dayDuties = getDutiesForDay(selectedDate);
      duties.addAll(dayDuties);
    }
  }

  bool isDaySelected(DateTime day) {
    return selectedDays.any(
      (selectedDay) =>
          selectedDay.day == day.day &&
          selectedDay.month == day.month &&
          selectedDay.year == day.year,
    );
  }

  List<Duty> getDutiesForDay(DateTime date) {
    // Find the day in weeksInMonth that matches the date
    for (final week in weeksInMonth) {
      for (final day in week.days) {
        if (day.date.year == date.year &&
            day.date.month == date.month &&
            day.date.day == date.day) {
          return day.duties;
        }
      }
    }
    return [];
  }

  final isLoadingMarkDuty = false.obs;
  final selectedDutyForMarking = Rxn<Duty>();

  void showMarkDutyBottomSheet() {
    if (selectedDuties.isEmpty) return;

    // Find the selected duty before clearing selection
    final selectedDuty = duties.firstWhere(
      (duty) => selectedDuties.contains(duty.id.toString()),
    );

    // Set the duty for marking
    selectedDutyForMarking.value = selectedDuty;

    // Clear the selection immediately when opening the bottom sheet
    selectedDuties.clear();

    // Reset ACT time fields
    actStartTime.value = '';
    actEndTime.value = '';
    isActStartTimePopulated.value = false;
    isActEndTimePopulated.value = false;

    // Auto-populate with planned times if actual times are not set
    if (selectedDuty.actualTimeIn == null ||
        selectedDuty.actualTimeIn!.isEmpty) {
      actStartTime.value = selectedDuty.timeIn;
    } else {
      actStartTime.value = selectedDuty.actualTimeIn!;
      isActStartTimePopulated.value = true;
    }

    if (selectedDuty.actualTimeOut == null ||
        selectedDuty.actualTimeOut!.isEmpty) {
      actEndTime.value = selectedDuty.timeOut;
    } else {
      actEndTime.value = selectedDuty.actualTimeOut!;
      isActEndTimePopulated.value = true;
    }

    Get.bottomSheet(
      MarkDutyBottomSheet(selectedDuty: selectedDuty),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }

  // Method to mark duty with actual times
  Future<void> markDuty() async {
    if (selectedDutyForMarking.value == null) return;

    final duty = selectedDutyForMarking.value!;

    // Validate that at least one time is provided
    if (actStartTime.value.isEmpty && actEndTime.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please provide at least one actual time (In or Out)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoadingMarkDuty.value = true;

    log(
      '[markDuty] dutyId: ${duty.id}, actualTimeIn: ${actStartTime.value}, actualTimeOut: ${actEndTime.value}',
    );

    try {
      final result = await MyRosterService.instance.markDuty(
        dutyId: duty.id,
        actualTimeIn: actStartTime.value,
        actualTimeOut: actEndTime.value,
      );

      isLoadingMarkDuty.value = false;

      if (result.isSuccess) {
        // Success handling
        Get.back(); // Close the bottom sheet

        // Update the local duty data
        final dutyIndex = duties.indexWhere((d) => d.id == duty.id);
        if (dutyIndex != -1) {
          duties[dutyIndex] = duties[dutyIndex].copyWith(
            actualTimeIn:
                actStartTime.value.isNotEmpty
                    ? actStartTime.value
                    : duty.actualTimeIn,
            actualTimeOut:
                actEndTime.value.isNotEmpty
                    ? actEndTime.value
                    : duty.actualTimeOut,
          );
          duties.refresh();
        }

        Get.snackbar(
          'Success',
          'Duty marked successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Refresh the data
        loadTodayRosterFromAPI();
        loadMonthlyRosterFromAPI();

        // Reset ACT time fields
        actStartTime.value = '';
        actEndTime.value = '';
        isActStartTimePopulated.value = false;
        isActEndTimePopulated.value = false;
      } else {
        // Error handling
        Get.snackbar(
          'Error',
          result.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingMarkDuty.value = false;
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void populateActStartTimeFromPln(String plnStartTime) {
    if (selectedDutyForMarking.value?.actualTimeIn == null ||
        selectedDutyForMarking.value!.actualTimeIn!.isEmpty) {
      actStartTime.value = plnStartTime;
      isActStartTimePopulated.value = true;
    }
  }

  void populateActEndTimeFromPln(String plnEndTime) {
    if (selectedDutyForMarking.value?.actualTimeOut == null ||
        selectedDutyForMarking.value!.actualTimeOut!.isEmpty) {
      actEndTime.value = plnEndTime;
      isActEndTimePopulated.value = true;
    }
  }

  Future<void> changeActStartTime() async {
    final currentDateTime = _parseDateTime(actStartTime.value);

    // Show date picker first
    final selectedDate = await Get.dialog<DateTime>(
      DatePickerDialog(
        initialDate: currentDateTime,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      ),
    );

    if (selectedDate != null) {
      // Show time picker
      final selectedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.fromDateTime(currentDateTime),
      );

      if (selectedTime != null) {
        final newDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        actStartTime.value = _formatDateTime(newDateTime);
      }
    }
  }

  Future<void> changeActEndTime() async {
    final currentDateTime = _parseDateTime(actEndTime.value);

    // Show date picker first
    final selectedDate = await Get.dialog<DateTime>(
      DatePickerDialog(
        initialDate: currentDateTime,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      ),
    );

    if (selectedDate != null) {
      // Show time picker
      final selectedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.fromDateTime(currentDateTime),
      );

      if (selectedTime != null) {
        final newDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        actEndTime.value = _formatDateTime(newDateTime);
      }
    }
  }

  DateTime _parseDateTime(String dateTimeString) {
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return DateTime.now();
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String formatTimeDisplay(String timeString) {
    if (timeString.contains(':')) {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}'; // Return HH:MM format
      }
    }
    return timeString; // Fallback
  }

  // Add these variables for break time functionality
  final isLoadingBreakTime = false.obs;
  final selectedDutyForBreak = Rxn<Duty>();

  void showAddBreakTimeBottomSheet() {
    // Initialize with default values

    breakTimeEntries.clear();
    breakTimeEntries.add(BreakTimeEntry(startTime: '', endTime: ''));

    Get.bottomSheet(
      const AddBreakTimeBottomSheet(),
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      enableDrag: false,
    );
  }

  // Method to submit break times
  Future<void> submitBreakTimes() async {
    print('[submitBreakTimes] Selected Duty Date: ${selectedDay.value}');

    // Validate break time entries
    final validBreakTimes = <Map<String, String>>[];

    for (final entry in breakTimeEntries) {
      if (entry.startTime.isNotEmpty && entry.endTime.isNotEmpty) {
        validBreakTimes.add({
          'start_time': entry.startTime,
          'end_time': entry.endTime,
        });
      }
    }

    if (validBreakTimes.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one valid break time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoadingBreakTime.value = true;

    try {
      final result = await MyRosterService.instance.addBreakTime(
        employeeId: todayRoster.value!.employeeId,
        breakDate:
            selectedDay.value != null
                ? _formatDate(selectedDay.value!)
                : _formatDate(DateTime.now()),
        breakTimes: validBreakTimes,
      );

      isLoadingBreakTime.value = false;

      if (result.isSuccess) {
        // Success handling
        Get.back(); // Close the bottom sheet
        Get.snackbar(
          'Success',
          'Break times added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Refresh the data
        loadTodayRosterFromAPI();
        loadMonthlyRosterFromAPI();
      } else {
        // Error handling
        Get.snackbar(
          'Error',
          result.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingBreakTime.value = false;
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Helper method to format date as YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Break time entry management methods
  void addBreakTimeEntry() {
    if (breakTimeEntries.length < 3) {
      breakTimeEntries.add(BreakTimeEntry(startTime: '', endTime: ''));
    }
  }

  void removeBreakTimeEntry(int index) {
    if (breakTimeEntries.length > 1) {
      breakTimeEntries.removeAt(index);
    }
  }

  void showManualTimeInputForBreakStart(int index) {
    showManualTimeInput(breakTimeEntries[index].startTime, (newTime) {
      final updatedEntry = BreakTimeEntry(
        startTime: newTime,
        endTime: breakTimeEntries[index].endTime,
      );
      breakTimeEntries[index] = updatedEntry;
    });
  }

  void showManualTimeInputForBreakEnd(int index) {
    showManualTimeInput(breakTimeEntries[index].endTime, (newTime) {
      final updatedEntry = BreakTimeEntry(
        startTime: breakTimeEntries[index].startTime,
        endTime: newTime,
      );
      breakTimeEntries[index] = updatedEntry;
    });
  }

  void showManualTimeInput(
    String currentTime,
    Function(String) onTimeSelected,
  ) {
    final textController = TextEditingController(text: currentTime);

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Set Time'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'HH:MM',
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey, width: 0.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          keyboardType: TextInputType.datetime,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
            LengthLimitingTextInputFormatter(5),
            TimeInputFormatter(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_validateTime(textController.text)) {
                onTimeSelected(textController.text);
                Get.back();
              } else {
                Get.snackbar(
                  'Invalid Time',
                  'Please enter time in HH:MM format (00:00 to 23:59)',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateTime(String time) {
    final regExp = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    return regExp.hasMatch(time);
  }

  // Future<void> selectBreakStartTimeForEntry(int index) async {
  //   final currentTime =
  //       breakTimeEntries[index].startTime.isNotEmpty
  //           ? _parseTimeString(breakTimeEntries[index].startTime)
  //           : TimeOfDay.now();

  //   final pickedTime = await showTimePicker(
  //     context: Get.context!,
  //     initialTime: currentTime,
  //   );

  //   if (pickedTime != null) {
  //     final timeString =
  //         '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
  //     final updatedEntry = BreakTimeEntry(
  //       startTime: timeString,
  //       endTime: breakTimeEntries[index].endTime,
  //     );
  //     breakTimeEntries[index] = updatedEntry;
  //   }
  // }

  // Future<void> selectBreakEndTimeForEntry(int index) async {
  //   final currentTime =
  //       breakTimeEntries[index].endTime.isNotEmpty
  //           ? _parseTimeString(breakTimeEntries[index].endTime)
  //           : TimeOfDay.now();

  //   final pickedTime = await showTimePicker(
  //     context: Get.context!,
  //     initialTime: currentTime,
  //   );

  //   if (pickedTime != null) {
  //     final timeString =
  //         '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
  //     final updatedEntry = BreakTimeEntry(
  //       startTime: breakTimeEntries[index].startTime,
  //       endTime: timeString,
  //     );
  //     breakTimeEntries[index] = updatedEntry;
  //   }
  // }

  // TimeOfDay _parseTimeString(String timeString) {
  //   try {
  //     final parts = timeString.split(':');
  //     if (parts.length == 2) {
  //       final hour = int.parse(parts[0]);
  //       final minute = int.parse(parts[1]);
  //       return TimeOfDay(hour: hour, minute: minute);
  //     }
  //   } catch (e) {
  //     // Fallback to default
  //   }
  //   return TimeOfDay(hour: 8, minute: 50);
  // }

  // Expand/collapse week functionality
  void toggleWeekExpansion(int weekNumber) {
    final isCurrentlyExpanded = expandedWeeks[weekNumber] ?? false;
    expandedWeeks[weekNumber] = !isCurrentlyExpanded;

    // If expanding, select all days with duties in this week
    if (!isCurrentlyExpanded) {
      selectAllDaysInWeek(weekNumber);
    } else {
      // If collapsing, clear all selections and duties
      selectedDays.clear();
      duties.clear();
    }
  }

  bool isWeekExpanded(int weekNumber) {
    return expandedWeeks[weekNumber] ?? false;
  }

  void expandWeek(int weekNumber) {
    expandedWeeks[weekNumber] = true;
  }

  void collapseWeek(int weekNumber) {
    expandedWeeks[weekNumber] = false;
  }

  void selectAllDaysInWeek(int weekNumber) {
    // Clear any existing selections
    selectedDays.clear();

    // Find the week and select all days that have duties
    final week = weeksInMonth.firstWhere((w) => w.number == weekNumber);
    final daysWithDuties = week.days.where((day) => day.duties.isNotEmpty);

    // Add all days with duties to selectedDays
    selectedDays.addAll(daysWithDuties.map((day) => day.date));

    // Update duties list
    _updateDutiesForSelectedDays();
  }

  // Get all duties for a specific week
  List<Duty> getAllDutiesForWeek(Week week) {
    List<Duty> allDuties = [];
    for (final day in week.days) {
      allDuties.addAll(day.duties);
    }
    return allDuties;
  }

  // Helper method to find which week a date belongs to
  Week? getWeekForDate(DateTime date) {
    for (final week in weeksInMonth) {
      if (week.days.any(
        (d) =>
            d.date.year == date.year &&
            d.date.month == date.month &&
            d.date.day == date.day,
      )) {
        return week;
      }
    }
    return null;
  }
}
