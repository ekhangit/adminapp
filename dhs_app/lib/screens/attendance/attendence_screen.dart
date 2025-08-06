import 'package:dhs_app/screens/attendance/widget/attendance_info.dart';
import 'package:dhs_app/screens/attendance/widget/check_in_button.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard/attendance_controller.dart';
import '../../controllers/storage/data_storage_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_image.dart';

import 'package:intl/intl.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DataStorageController.to.user;
    final controller = Get.put(AttendanceController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.colorSecondary,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            // 🔵 Top Section
            Container(
              height: 280,
              width: double.infinity,
              color: AppColors.colorPrimary,
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomImage(
                            imageUrl: 'assets/images/profile.jpg',
                            isNetwork: false,
                            borderColor: Colors.white,
                            size: 50.0,
                          ),
                          SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.name.isNotEmpty ? user.name : "",
                                style: TextStyle(
                                  color: AppColors.colorSecondary.withValues(
                                    alpha: 0.75,
                                  ),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Mark Your Attendance!",
                                style: TextStyle(
                                  color: AppColors.colorSecondary,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ⚪ White content starting after the top, but height wraps content
            Column(
              children: [
                const SizedBox(height: 200),
                Container(
                  padding: EdgeInsets.all(32.0),
                  margin: EdgeInsets.symmetric(horizontal: 32.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => Text(
                          controller.currentTime.value,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.currentDate.value,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightGreyTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Obx(
                        () => CheckInButton(
                          iconPath: 'assets/svg/clockin.svg',
                          title:
                              controller.isClockedIn.value
                                  ? 'CLOCK OUT'
                                  : 'CLOCK IN',
                          isClockedIn: controller.isClockedIn.value,
                          disabled:
                              controller.isButtonDisabled ||
                              (controller.locationRequired.value &&
                                  (!controller.locationServiceEnabled.value ||
                                      !controller
                                          .locationPermissionGranted
                                          .value)),
                          onTap:
                              controller.isButtonDisabled
                                  ? null
                                  : () async {
                                    // Check if biometrics are available
                                    bool canUseBiometrics =
                                        await controller.authService
                                            .canAuthenticateWithBiometrics();
                                    if (!canUseBiometrics) {
                                      // Show confirmation dialog for fallback
                                      bool? confirmed = await Get.dialog<bool>(
                                        AlertDialog(
                                          title: Text(
                                            controller.isClockedIn.value
                                                ? 'Confirm Clock Out'
                                                : 'Confirm Clock In',
                                          ),
                                          content: Text(
                                            'Biometric authentication is not available. Do you want to ${controller.isClockedIn.value ? 'clock out' : 'clock in'} manually?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Get.back(result: false),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Get.back(result: true),
                                              child: Text('Confirm'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirmed != true) return;
                                    }
                                    // Proceed with clock action
                                    final success =
                                        await controller.handleClockAction();
                                    // if (!success && canUseBiometrics) {
                                    //   ScaffoldMessenger.of(
                                    //     context,
                                    //   ).showSnackBar(
                                    //     const SnackBar(
                                    //       content: Text(
                                    //         'Authentication failed',
                                    //       ),
                                    //     ),
                                    //   );
                                    // }
                                  },
                        ),
                      ),
                      const SizedBox(height: 30),
                      DottedLine(
                        dashLength: 4.0,
                        dashColor: AppColors.lightGreyTextColor.withOpacity(
                          0.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => AttendanceInfoTile(
                              title: "Clock In",
                              value:
                                  controller.clockInTime.value != null
                                      ? DateFormat(
                                        'hh:mm a',
                                      ).format(controller.clockInTime.value!)
                                      : "--:--",
                              iconPath: 'assets/svg/timer.svg',
                            ),
                          ),
                          Obx(
                            () => AttendanceInfoTile(
                              title: "Clock Out",
                              value:
                                  controller.clockOutTime.value != null
                                      ? DateFormat(
                                        'hh:mm a',
                                      ).format(controller.clockOutTime.value!)
                                      : "--:--",
                              iconPath: 'assets/svg/timer.svg',
                            ),
                          ),
                          Obx(
                            () => AttendanceInfoTile(
                              title: "Total Hrs",
                              value:
                                  controller.totalWorkedHours.value.isNotEmpty
                                      ? controller.totalWorkedHours.value
                                      : "--:--",
                              iconPath: 'assets/svg/timer.svg',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // 🌀 Loading Overlay
            Obx(
              () =>
                  controller.isLoading.value
                      ? Container(
                        color: Colors.black.withValues(alpha: 0.5),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.85),
                              boxShadow: kElevationToShadow[1],
                              border: Border.all(
                                color: AppColors.matteBlackColor,
                                width: 0.05,
                              ),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                color: AppColors.colorPrimary,
                              ),
                            ),
                          ),
                        ),
                      )
                      : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
