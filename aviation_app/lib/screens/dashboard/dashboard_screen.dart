import 'package:aviation_app/screens/flightcomm/flightcomm_screen.dart';
import 'package:aviation_app/screens/leave/leave_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constant.dart';
import '../../controllers/storage/data_storage_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_box.dart';
import '../attendance/attendence_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DataStorageController.to.user;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Stack(
        children: [
          // 🔵 Top Section
          Container(
            height: 150,
            width: double.infinity,
            color: AppColors.colorWhite,
            child: SafeArea(
              bottom: false,
              child: Container(
                // color: Colors.yellow,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.colorPrimary.withOpacity(0.2),
                      child: Text(
                        user.name.isNotEmpty ? user.name[0] : "?",
                        style: TextStyle(
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            color: AppColors.colorPrimary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Munich",
                          style: TextStyle(
                            color: AppColors.colorPrimary,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.colorPrimary.withOpacity(0.2),
                      child: Icon(
                        Icons.notifications,
                        color: AppColors.colorPrimary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ⚪ White content starting after the top, but height wraps content
          Column(
            children: [
              const SizedBox(height: 150), // Offset to clear top container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: AppColors.colorPrimary.withOpacity(0.95),
                    gradient: appThemeGradientSoft2,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          spacing: 12,
                          children: [
                            CustomBox2(
                              title: 'Attendance',
                              iconPath: 'assets/images/hr_final.png',
                              onTap:
                                  () => Get.to(() => const AttendenceScreen()),
                            ),
                            CustomBox2(
                              title: 'Flight Comm',
                              iconPath: 'assets/images/flight_comm_final.png',
                              onTap:
                                  () => Get.to(() => const FlightcommScreen()),
                            ),

                            CustomBox2(
                              title: 'My Roster',
                              iconPath: 'assets/images/my_duties_final.png',
                              onTap: () => (),
                            ),
                            CustomBox2(
                              title: 'PTS',
                              iconPath: 'assets/images/airlines_final.png',
                              onTap: () => (),
                            ),

                            CustomBox2(
                              title: 'Flight Tracker',
                              iconPath:
                                  'assets/images/flight_tracker_final.png',
                              onTap: () => (),
                            ),
                            CustomBox2(
                              title: 'Flight Watch',
                              iconPath: 'assets/images/flight_watch_final.png',
                              onTap: () => (),
                            ),
                            CustomBox2(
                              title: 'Leave Request',
                              iconPath: 'assets/images/airlines_final.png',
                              onTap:
                                  () =>
                                      Get.to(() => const LeaveRequestScreen()),
                            ),
                            CustomBox2(
                              title: 'Staff Watch',
                              iconPath: 'assets/images/staff_watch_final.png',
                              onTap: () => (),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
