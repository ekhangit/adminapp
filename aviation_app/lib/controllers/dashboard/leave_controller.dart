import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/leave_model.dart';
import '../../services/leave_service.dart';

class LeaveRequestController extends GetxController {
  // Input fields
  var description = ''.obs;
  var reason = ''.obs;
  var selectedLeaveType = ''.obs;
  var fromDate = ''.obs;
  var toDate = ''.obs;

  var totalDays = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaveTypes();

    everAll([fromDate, toDate], (_) {
      if (fromDate.isNotEmpty && toDate.isNotEmpty) {
        calculateTotalDays();
      } else {
        totalDays.value = 0;
      }
    });
  }

  // Observable variables for leave types
  RxList<LeaveTypeModel> leaveModes = <LeaveTypeModel>[].obs;

  // Method to fetch leave types
  Future<void> fetchLeaveTypes() async {
    isLoading.value = true;
    try {
      final response = await LeaveService.instance.leaveTypes();
      if (response.isSuccess) {
        leaveModes.assignAll(response.data!);
      } else {
        Get.snackbar('Error', 'Failed to fetch leave types');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch leave types');
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate total days when dates from api
  Future<void> calculateTotalDays() async {
    if (fromDate.isNotEmpty && toDate.isNotEmpty) {
      String formattedFromDate = _reformatDate(fromDate.value);
      String formattedToDate = _reformatDate(toDate.value);

      print(
        'Calculating total days from $formattedFromDate to $formattedToDate',
      );

      // Validate dates to prevent invalid API calls
      try {
        final fromDateTime = DateTime.parse(formattedFromDate);
        final toDateTime = DateTime.parse(formattedToDate);
        if (toDateTime.isBefore(fromDateTime)) {
          Get.snackbar('Error', 'To date cannot be before From date');
          totalDays.value = 0;
          return;
        }
      } catch (e) {
        Get.snackbar('Error', 'Invalid date format: $e');
        totalDays.value = 0;
        return;
      }

      try {
        final response = await LeaveService.instance.calculateTotalDays(
          fromDate: formattedFromDate,
          toDate: formattedToDate,
        );
        print(
          'API Response: isSuccess=${response.isSuccess}, data=${response.data}',
        );

        if (response.isSuccess) {
          totalDays.value =
              response.data! as String == '0'
                  ? 0
                  : int.tryParse(response.data!) ?? 0;
        } else {
          Get.snackbar(
            'Error',
            'Failed to calculate total days: ${response.isSuccess ? "Invalid data" : "API error"}',
          );
          totalDays.value = 0;
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to calculate total days: $e');
        totalDays.value = 0;
      }
    } else {
      totalDays.value = 0;
    }
  }

  // Button state
  var isLoading = false.obs;

  bool get canContinue =>
      description.isNotEmpty &&
      reason.isNotEmpty &&
      selectedLeaveType.isNotEmpty &&
      fromDate.isNotEmpty &&
      toDate.isNotEmpty;

  void selectType(String type) {
    selectedLeaveType.value = type;
  }

  // Future<void> submitRequest() async {
  //   // Defensive validation
  //   if (!canContinue) {
  //     Get.snackbar("Validation Error", "Please complete all required fields.");
  //     return;
  //   }

  //   final from =
  //       DateTime.tryParse(fromDate.value) ??
  //       DateTime.parse(_reformatDate(fromDate.value));
  //   final to =
  //       DateTime.tryParse(toDate.value) ??
  //       DateTime.parse(_reformatDate(toDate.value));

  //   if (to.isBefore(from)) {
  //     Get.snackbar("Validation Error", "To date cannot be before From date.");
  //     return;
  //   }

  //   isLoading.value = true;

  //   await Future.delayed(const Duration(seconds: 2)); // simulate API call

  //   // Success
  //   Get.snackbar("Success", "Leave request submitted successfully!");

  //   // Reset all fields
  //   description.value = '';
  //   reason.value = '';
  //   selectedLeaveType.value = '';
  //   fromDate.value = '';
  //   toDate.value = '';
  //   isLoading.value = false;
  // }

  // Helper to parse dd MMM, yyyy into yyyy-MM-dd
  String _reformatDate(String input) {
    final parts = input.split(' ');
    if (parts.length != 3) return input;
    final day = parts[0];
    final month = _monthNameToNumber(parts[1]);
    final year = parts[2];
    return '$year-$month-$day';
  }

  String _monthNameToNumber(String month) {
    const months = {
      'Jan': '01',
      'Feb': '02',
      'Mar': '03',
      'Apr': '04',
      'May': '05',
      'Jun': '06',
      'Jul': '07',
      'Aug': '08',
      'Sep': '09',
      'Oct': '10',
      'Nov': '11',
      'Dec': '12',
    };
    return months[month] ?? '01';
  }

  // Submit leave request from api
  Future<void> submitLeaveRequest() async {
    // if (!canContinue) {
    //   Get.snackbar("Validation Error", "Please complete all required fields.");
    //   return;
    // }

    isLoading.value = true;

    try {
      final response = await LeaveService.instance.submitLeaveRequest(
        leaveTypeId:
            leaveModes
                .firstWhere((type) => type.title == selectedLeaveType.value)
                .id,
        fromDate: _reformatDate(fromDate.value),
        toDate: _reformatDate(toDate.value),
        totalLeaveDays: totalDays.value,
        leaveReason: reason.value,
      );

      if (response.isSuccess) {
        Get.snackbar("Success", "Leave request submitted successfully!");
        // Reset fields after successful submission
        description.value = '';
        reason.value = '';
        selectedLeaveType.value = '';
        fromDate.value = '';
        toDate.value = '';
      } else {
        Get.snackbar("Error", response.errorMessage);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while submitting request: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
