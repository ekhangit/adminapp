import 'dart:async';

import 'package:aviation_app/services/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/local_auth_service.dart';
import '../../services/user_location_service.dart';

class AttendanceController extends GetxController {
  final LocalAuthService authService = LocalAuthService();

  var isClockedIn = false.obs;
  var currentTime = ''.obs;
  var currentDate = ''.obs;
  var isLoading = true.obs;

  var clockInTime = Rxn<DateTime>();
  var clockOutTime = Rxn<DateTime>();
  var totalWorkedHours = ''.obs;

  // Computed observable to determine if CheckInButton should be disabled
  bool get isButtonDisabled =>
      clockInTime.value != null &&
      clockOutTime.value != null &&
      totalWorkedHours.value.isNotEmpty &&
      totalWorkedHours.value != "--:--";

  late Timer _timer;

  var locationPermissionGranted = false.obs;
  var locationServiceEnabled = false.obs;
  var locationRequired = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
    updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => updateTime());
    Future.delayed(Duration(milliseconds: 100), () {
      _initializeAttendance();
    });
  }

  // void updateTime() {
  //   final now = DateTime.now();
  //   currentTime.value = DateFormat('hh : mm a').format(now);
  //   currentDate.value = DateFormat('MMMM dd, yyyy - EEEE').format(now);
  // }

  void updateTime() {
    final now = DateTime.now().toUtc(); // Convert to UTC
    currentTime.value = DateFormat('hh : mm a').format(now);
    currentDate.value = DateFormat('MMMM dd, yyyy - EEEE').format(now);
  }

  Future<void> _initializeLocation() async {
    try {
      // 1. Check if location is required from API
      final locationResponse =
          await UserLocationService.instance.checkLocation();
      locationRequired.value =
          locationResponse.isSuccess &&
          locationResponse.data != null &&
          locationResponse.data!['location_required'] == "yes";

      if (!locationRequired.value) return;

      // 2. Check current location status
      await _checkLocationStatus();

      // 3. If required but not enabled, show prompt
      if (locationRequired.value &&
          (!locationServiceEnabled.value || !locationPermissionGranted.value)) {
        await _requestLocationAccess();
      }
    } catch (e) {
      print("Error initializing location: $e");
    }
  }

  Future<void> _checkLocationStatus() async {
    locationServiceEnabled.value = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();
    locationPermissionGranted.value =
        permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  // check local permissions
  Future<bool> _requestLocationAccess() async {
    try {
      // 1. Check if service is enabled
      if (!locationServiceEnabled.value) {
        locationServiceEnabled.value = await Geolocator.openLocationSettings();
        if (!locationServiceEnabled.value) {
          Get.snackbar(
            "Location Required",
            "Please enable location services",
            duration: Duration(seconds: 3),
          );
          return false;
        }
      }

      // 2. Check permissions
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            "Permission Required",
            "Location permission is required",
            duration: Duration(seconds: 3),
          );
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission Denied",
          "Please enable location in app settings",
          duration: Duration(seconds: 3),
        );
        await openAppSettings();
        return false;
      }

      // 3. Update status after successful request
      await _checkLocationStatus();
      return locationPermissionGranted.value;
    } catch (e) {
      print("Error requesting location access: $e");
      return false;
    }
  }

  Future<void> _initializeAttendance() async {
    try {
      isLoading.value = true;
      print("Initializing attendance...");
      final response = await AttendanceService.instance.trackAttendance();
      print("TrackAttendance response received: ${response.data}");

      if (response.isSuccess && response.data != null) {
        Map<String, dynamic> attendanceData;

        if (response.data!.containsKey('body')) {
          attendanceData = response.data!['body'];
          print("Using response body: $attendanceData");
        } else {
          attendanceData = response.data!;
          print("Using direct response data: $attendanceData");
        }

        if (attendanceData['clock_in'] != null &&
            attendanceData['clock_in'] != 'null') {
          try {
            final timeString = attendanceData['clock_in'].toString();
            print("Parsing clock_in time: $timeString");

            if (timeString.contains(':')) {
              final now = DateTime.now();
              final timeParts = timeString.split(':');
              if (timeParts.length == 2) {
                final hour = int.parse(timeParts[0]);
                final minute = int.parse(timeParts[1]);
                clockInTime.value = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  hour,
                  minute,
                );
                print("Clock-in time set: ${clockInTime.value}");
              }
            } else {
              clockInTime.value = DateTime.parse(timeString);
            }
          } catch (e) {
            print("Error parsing clock_in time: $e");
            clockInTime.value = null;
          }
        } else {
          clockInTime.value = null;
          print("Clock-in is null");
        }

        if (attendanceData['clock_out'] != null &&
            attendanceData['clock_out'] != 'null') {
          try {
            final timeString = attendanceData['clock_out'].toString();
            print("Parsing clock_out time: $timeString");

            if (timeString.contains(':')) {
              final now = DateTime.now();
              final timeParts = timeString.split(':');
              if (timeParts.length == 2) {
                final hour = int.parse(timeParts[0]);
                final minute = int.parse(timeParts[1]);
                clockOutTime.value = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  hour,
                  minute,
                );
                print("Clock-out time set: ${clockOutTime.value}");
              }
            } else {
              clockOutTime.value = DateTime.parse(timeString);
            }
          } catch (e) {
            print("Error parsing clock_out time: $e");
            clockOutTime.value = null;
          }
        } else {
          clockOutTime.value = null;
          print("Clock-out is null");
        }

        if (attendanceData['total_hours'] != null &&
            attendanceData['total_hours'] != 'null') {
          totalWorkedHours.value = attendanceData['total_hours'].toString();
          print("Total hours set: ${totalWorkedHours.value}");
        } else {
          totalWorkedHours.value = "--:--";
          print("Total hours is null, set to --:--");
        }

        _updateUIState();
      } else {
        print("Failed to load attendance data or response is not successful");
        _resetAttendanceState();
      }
    } catch (e) {
      print("Error loading attendance data: $e");
      _resetAttendanceState();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateUIState() {
    print("Updating UI state...");
    print("clockInTime: ${clockInTime.value}");
    print("clockOutTime: ${clockOutTime.value}");

    if (clockInTime.value == null) {
      isClockedIn.value = false;
      totalWorkedHours.value = "--:--";
      print("UI State: Ready for CLOCK IN");
    } else if (clockInTime.value != null && clockOutTime.value == null) {
      isClockedIn.value = true;
      if (totalWorkedHours.value == 'null' || totalWorkedHours.value.isEmpty) {
        totalWorkedHours.value = "--:--";
      }
      print(
        "UI State: Ready for CLOCK OUT (Currently clocked in) - isClockedIn: ${isClockedIn.value}",
      );
    } else if (clockInTime.value != null && clockOutTime.value != null) {
      isClockedIn.value = false;
      print("UI State: Attendance completed for today");
    }

    update();
  }

  void _resetAttendanceState() {
    clockInTime.value = null;
    clockOutTime.value = null;
    isClockedIn.value = false;
    totalWorkedHours.value = "--:--";
  }

  /// Handle clock action with biometric or fallback
  Future<bool> handleClockAction() async {
    // First check location requirements
    if (locationRequired.value) {
      await _checkLocationStatus();

      if (!locationServiceEnabled.value || !locationPermissionGranted.value) {
        final success = await _requestLocationAccess();
        if (!success) return false;
      }

      // Final verification after potential changes
      await _checkLocationStatus();
      if (!locationServiceEnabled.value || !locationPermissionGranted.value) {
        Get.snackbar(
          "Location Required",
          "Cannot proceed without location access",
          duration: Duration(seconds: 3),
        );
        return false;
      }
    }

    final now = DateTime.now();

    // Check if attendance is already completed
    if (clockInTime.value != null && clockOutTime.value != null) {
      Get.snackbar(
        "Already Completed",
        "You've already completed your attendance for today.",
      );
      return false;
    }

    // Check if biometrics are available
    bool canUseBiometrics = await authService.canAuthenticateWithBiometrics();
    bool isAuthenticated = false;

    if (canUseBiometrics) {
      // Try biometric authentication
      isAuthenticated = await authService.authenticateWithBiometrics();
      if (!isAuthenticated) {
        Get.snackbar(
          "Authentication Failed",
          "Biometric authentication failed. Please try again or use manual clock-in/out.",
        );
        return false;
      }
    }

    // If biometrics are unavailable or user chooses fallback, proceed with clock action
    if (canUseBiometrics && isAuthenticated || !canUseBiometrics) {
      if (clockInTime.value == null) {
        return await _performClockIn(now);
      } else if (clockInTime.value != null && clockOutTime.value == null) {
        return await _performClockOut(now);
      }
    }

    return false;
  }

  Future<bool> _performClockIn(DateTime now) async {
    try {
      final clockInResponse = await clockIn();
      if (!clockInResponse) {
        Get.snackbar(
          "Clock In Failed",
          "Failed to clock in. Please try again.",
        );
        return false;
      }

      clockInTime.value = now;
      isClockedIn.value = true;
      clockOutTime.value = null;
      totalWorkedHours.value = "--:--";

      Get.snackbar(
        "Success",
        "Clocked in successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      print("Error during clock-in: $e");
      Get.snackbar("Error", "An error occurred during clock-in.");
      return false;
    }
  }

  Future<bool> _performClockOut(DateTime now) async {
    try {
      final clockOutResponse = await clockOut();
      if (!clockOutResponse) {
        Get.snackbar(
          "Clock Out Failed",
          "Failed to clock out. Please try again.",
        );
        return false;
      }

      clockOutTime.value = now;
      isClockedIn.value = false;

      if (clockInTime.value != null) {
        final duration = now.difference(clockInTime.value!);
        totalWorkedHours.value = _formatDuration(duration);
      }

      await _initializeAttendance();

      Get.snackbar(
        "Success",
        "Clocked out successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      print("Error during clock-out: $e");
      Get.snackbar("Error", "An error occurred during clock-out.");
      return false;
    }
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

  Future<bool> clockIn() async {
    try {
      final response = await AttendanceService.instance.clockIn();

      if (response) {
        print("Clock-in API call successful");
        return true;
      } else {
        print("Clock-in API call failed");
        return false;
      }
    } catch (e) {
      print("Error during clock-in: $e");
      return false;
    }
  }

  Future<bool> clockOut() async {
    try {
      final response = await AttendanceService.instance.clockOut();
      if (response) {
        print("Clock-out API call successful");
        return true;
      } else {
        print("Clock-out API call failed");
        return false;
      }
    } catch (e) {
      print("Error during clock-out: $e");
      return false;
    }
  }
}
