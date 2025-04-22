import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../services/local_auth_service.dart';

class AttendanceController extends GetxController {
  final AuthService _authService = AuthService();

  var isClockedIn = false.obs;
  var currentTime = ''.obs;
  var currentDate = ''.obs;

  var clockInTime = Rxn<DateTime>();
  var clockOutTime = Rxn<DateTime>();
  var totalWorkedHours = ''.obs;

  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => updateTime());
  }

  void updateTime() {
    final now = DateTime.now();
    currentTime.value = DateFormat('hh : mm a').format(now);
    currentDate.value = DateFormat('MMMM dd, yyyy - EEEE').format(now);
  }

  /// ✅ Restrict clock in/out to once per day
  Future<bool> handleBiometricClockAction() async {
    final isAuthenticated = await _authService.authenticateWithBiometrics();
    if (!isAuthenticated) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 🕐 Block if already clocked in today
    if (!isClockedIn.value) {
      if (clockInTime.value != null && _isSameDay(clockInTime.value!, today)) {
        Get.snackbar("Already Clocked In", "You've already clocked in today.");
        return false;
      }

      // ✅ First clock in
      clockInTime.value = now;
      isClockedIn.value = true;
      clockOutTime.value = null;
      totalWorkedHours.value = "--:--";
    } else {
      if (clockOutTime.value != null &&
          _isSameDay(clockOutTime.value!, today)) {
        Get.snackbar(
          "Already Clocked Out",
          "You've already clocked out today.",
        );
        return false;
      }

      // ✅ Clocking out
      clockOutTime.value = now;
      isClockedIn.value = false;

      if (clockInTime.value != null) {
        final duration = now.difference(clockInTime.value!);
        totalWorkedHours.value = _formatDuration(duration);
      }
    }

    return true;
  }

  bool _isSameDay(DateTime date, DateTime compareTo) {
    return date.year == compareTo.year &&
        date.month == compareTo.month &&
        date.day == compareTo.day;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
