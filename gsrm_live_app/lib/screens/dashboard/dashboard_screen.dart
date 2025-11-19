import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';
import '../../controllers/flight/airline_controller.dart';
import '../../controllers/storage/data_storage_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_box.dart';
import '../attendance/attendence_screen.dart';
import '../flightcomm/flight_comm_screen.dart';
import '../leave/leave_request_screen.dart';
import '../myroster/my_roster_screen.dart';
import '../pts/pts_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DataStorageController.to.user;

    // Initialize AirlineController to cache airlines
    Get.put(AirlineController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Stack(
        children: [
          // 🔵 Top Section
          Container(
            height: 135,
            width: double.infinity,
            color: AppColors.colorWhite,
            child: SafeArea(
              bottom: false,
              child: Container(
                // decoration: BoxDecoration(color: Colors.yellow),
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.colorPrimary.withValues(
                        alpha: 0.2,
                      ),
                      child: Text(
                        user.name.isNotEmpty ? user.name[0] : "?",
                        style: GoogleFonts.roboto(
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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
                          style: GoogleFonts.roboto(
                            color: AppColors.colorPrimary,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.colorPrimary.withValues(
                        alpha: 0.2,
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: AppColors.colorPrimary,
                        size: 24,
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
              const SizedBox(height: 135), // Offset to clear top container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: AppColors.colorPrimary.withOpacity(0.95),
                    gradient: appThemeGradientSoft2,
                    // borderRadius: BorderRadius.only(
                    //   topRight: Radius.circular(24),
                    //   topLeft: Radius.circular(24),
                    // ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate item height to fit all 8 items (4 rows) without scrolling
                      final availableHeight = constraints.maxHeight;
                      final itemHeight =
                          (availableHeight - 20) /
                          4; // 4 rows with some padding

                      return GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio:
                            (constraints.maxWidth / 2) / itemHeight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          CustomBox2(
                            title: 'Attendance',
                            iconPath: 'assets/images/hr_final.png',
                            onTap: () => Get.to(() => const AttendanceScreen()),
                          ),
                          CustomBox2(
                            title: 'Flight Comm',
                            iconPath: 'assets/images/flight_comm_final.png',
                            onTap: () => Get.to(() => const FlightCommScreen()),
                          ),
                          CustomBox2(
                            title: 'My Roster',
                            iconPath: 'assets/images/my_duties_final.png',
                            onTap: () => Get.to(() => MyRosterScreen()),
                          ),
                          CustomBox2(
                            title: 'PTS',
                            iconPath: 'assets/images/airlines_final.png',
                            onTap: () => Get.to(() => const PtsScreen()),
                          ),
                          CustomBox2(
                            title: 'Flight Tracker',
                            iconPath: 'assets/images/flight_tracker_final.png',
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
                                () => Get.to(() => const LeaveRequestScreen()),
                          ),
                          CustomBox2(
                            title: 'Staff Watch',
                            iconPath: 'assets/images/staff_watch_final.png',
                            onTap: () => (),
                          ),
                        ],
                      );
                    },
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
