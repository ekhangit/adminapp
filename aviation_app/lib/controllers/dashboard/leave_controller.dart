import 'package:get/get.dart';
import 'package:intl/intl.dart';


class LeaveRequestController extends GetxController {
  // Input fields
  var description = ''.obs;
  var reason = ''.obs;
  var selectedLeaveType = ''.obs;
  var fromDate = ''.obs;
  var toDate = ''.obs;

  var totalDays = 0.obs;

  // Leave options
  final List<String> leaveModes = ['Annual Leave', 'new'];

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

  Future<void> submitRequest() async {
    // Defensive validation
    if (!canContinue) {
      Get.snackbar("Validation Error", "Please complete all required fields.");
      return;
    }

    final from =
        DateTime.tryParse(fromDate.value) ??
        DateTime.parse(_reformatDate(fromDate.value));
    final to =
        DateTime.tryParse(toDate.value) ??
        DateTime.parse(_reformatDate(toDate.value));

    if (to.isBefore(from)) {
      Get.snackbar("Validation Error", "To date cannot be before From date.");
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2)); // simulate API call

    // Success
    Get.snackbar("Success", "Leave request submitted successfully!");

    // Reset all fields
    description.value = '';
    reason.value = '';
    selectedLeaveType.value = '';
    fromDate.value = '';
    toDate.value = '';
    isLoading.value = false;
  }

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

  void calculateTotalDays() {
    if (fromDate.value.isNotEmpty && toDate.value.isNotEmpty) {
      final from = DateFormat('dd MMM, yyyy').parse(fromDate.value);
      final to = DateFormat('dd MMM, yyyy').parse(toDate.value);

      final days = to.difference(from).inDays + 1; // inclusive
      totalDays.value = days.clamp(0, 999);
    }
  }
}
