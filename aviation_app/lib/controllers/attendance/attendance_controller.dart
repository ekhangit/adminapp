import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../services/local_auth_service.dart';

class AttendanceController extends GetxController {
  final AuthService _authService = AuthService();
  var isClockedIn = false.obs;
  var currentTime = ''.obs;
  var currentDate = ''.obs;

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

  void toggleClockStatus() {
    isClockedIn.value = !isClockedIn.value;
  }

  Future<bool> handleBiometricClockAction() async {
    final isAuthenticated = await _authService.authenticateWithBiometrics();

    if (isAuthenticated) {
      isClockedIn.value = !isClockedIn.value; // Toggle state
      return true;
    }

    return false;
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
