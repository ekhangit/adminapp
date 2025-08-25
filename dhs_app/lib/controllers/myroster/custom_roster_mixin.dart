import 'dart:developer';

import 'package:get/get.dart';

import '../../models/roster_models.dart';
import '../../services/my_roster_service.dart';

mixin CustomRosterMixin on GetxController {
  // Custom date range observables
  final customFromDate = Rxn<DateTime>();
  final customToDate = Rxn<DateTime>();
  final isCustomDateRangeSelected = false.obs;
  final isLoadingCustomRoster = false.obs;
  final customRosterWeeks = <Week>[].obs;
  final customSelectedDays = <DateTime>[].obs;
  final customSelectedDuties = <String>[].obs;

  // Initialize with default date range (current week)
  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    customFromDate.value = now.subtract(Duration(days: now.weekday - 1));
    customToDate.value = customFromDate.value!.add(const Duration(days: 6));
  }

  // Load custom roster based on selected date range
  Future<void> loadCustomRosterFromAPI() async {
    if (customFromDate.value == null || customToDate.value == null) {
      Get.snackbar('Error', 'Please select both from and to dates');
      return;
    }

    isLoadingCustomRoster.value = true;
    try {
      log(
        'Loading custom roster from ${customFromDate.value} to ${customToDate.value}',
      );

      final response = await MyRosterService.instance.customRangeRoster(
        fromDate: customFromDate.value!.toString(),
        toDate: customToDate.value!.toString(),
      );

      if (response.isSuccess) {
        final result = response.data as List<Week>;
        customRosterWeeks.value = result;

        // Clear previous selections
        customSelectedDays.clear();
        customSelectedDuties.clear();

        // Get.snackbar('Success', 'Custom roster loaded successfully');
      } else {
        print('Failed to load custom roster: ${response.errorMessage}');
        // Get.snackbar('Error', response.errorMessage);
      }
    } catch (e) {
      print('Error loading custom roster: $e');
      // Get.snackbar('Error', 'Failed to load custom roster: $e');
    } finally {
      isLoadingCustomRoster.value = false;
    }
  }

  // Select custom date range
  void selectCustomDateRange(DateTime fromDate, DateTime toDate) {
    customFromDate.value = fromDate;
    customToDate.value = toDate;
    isCustomDateRangeSelected.value = true;
    loadCustomRosterFromAPI();
  }

  // Reset to default view (current month)
  void resetToDefaultView() {
    isCustomDateRangeSelected.value = false;
    customSelectedDays.clear();
    customSelectedDuties.clear();
    customFromDate.value = null;
    customToDate.value = null;
  }

  // Select day in custom roster
  void selectCustomDay(DateTime day) {
    final existingIndex = customSelectedDays.indexWhere(
      (selectedDay) =>
          selectedDay.day == day.day &&
          selectedDay.month == day.month &&
          selectedDay.year == day.year,
    );

    if (existingIndex != -1) {
      customSelectedDays.removeAt(existingIndex);
    } else {
      customSelectedDays.add(day);
    }

    _updateCustomDutiesForSelectedDays();
  }

  void _updateCustomDutiesForSelectedDays() {
    // Clear existing duties
    customSelectedDuties.clear();

    // Add duties from all selected days
    for (final selectedDate in customSelectedDays) {
      final dayDuties = getCustomDutiesForDay(selectedDate);
      for (final duty in dayDuties) {
        customSelectedDuties.add(duty.id.toString());
      }
    }
  }

  List<Duty> getCustomDutiesForDay(DateTime date) {
    for (final week in customRosterWeeks) {
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

  bool isCustomDaySelected(DateTime day) {
    return customSelectedDays.any(
      (selectedDay) =>
          selectedDay.day == day.day &&
          selectedDay.month == day.month &&
          selectedDay.year == day.year,
    );
  }

  // Get formatted date range string
  String get formattedDateRange {
    if (customFromDate.value == null || customToDate.value == null) {
      return 'Select Date Range';
    }

    final from = customFromDate.value!;
    final to = customToDate.value!;

    if (from.year == to.year && from.month == to.month) {
      return '${from.day} - ${to.day} ${_getMonthName(from.month)} ${from.year}';
    } else if (from.year == to.year) {
      return '${from.day} ${_getMonthName(from.month)} - ${to.day} ${_getMonthName(to.month)} ${from.year}';
    } else {
      return '${from.day} ${_getMonthName(from.month)} ${from.year} - ${to.day} ${_getMonthName(to.month)} ${to.year}';
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return monthNames[month - 1];
  }

  // Check if a date is within the selected range
  bool isDateInRange(DateTime date) {
    if (customFromDate.value == null || customToDate.value == null) {
      return false;
    }

    return date.isAfter(
          customFromDate.value!.subtract(const Duration(days: 1)),
        ) &&
        date.isBefore(customToDate.value!.add(const Duration(days: 1)));
  }

  // Get total hours for selected custom period
  double getTotalHoursForCustomPeriod() {
    double totalHours = 0;

    for (final week in customRosterWeeks) {
      for (final day in week.days) {
        if (isDateInRange(day.date) && day.totalPeriodHours.isNotEmpty) {
          totalHours += double.tryParse(day.totalPeriodHours) ?? 0;
        }
      }
    }

    return totalHours;
  }

  // Get number of working days in custom period
  int getWorkingDaysCount() {
    int count = 0;

    for (final week in customRosterWeeks) {
      for (final day in week.days) {
        if (isDateInRange(day.date) && day.hasDuties) {
          count++;
        }
      }
    }

    return count;
  }
}
