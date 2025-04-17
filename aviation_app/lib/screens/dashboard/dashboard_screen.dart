import 'package:aviation_app/screens/leave/leave_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../widgets/custom_box.dart';
import '../../widgets/custom_image.dart';
import '../attendance/attendence_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Stack(
        children: [
          // 🔵 Top Section
          Container(
            height: 200,
            width: double.infinity,
            color: AppColors.colorPrimary,
            alignment: Alignment.topCenter,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Morning",
                          style: TextStyle(
                            color: AppColors.colorSecondary,
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Hey Muhammad!",
                          style: TextStyle(
                            color: AppColors.colorSecondary,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    CustomCircularImage(
                      imageUrl: 'assets/images/profile.jpg',
                      isNetwork: false,
                      borderColor: Colors.white,
                      size: 50.0,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ⚪ White content starting after the top, but height wraps content
          Column(
            children: [
              const SizedBox(height: 180), // Offset to clear top container
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 32.0,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          CustomBox(
                            title: 'Attendance',
                            iconPath: 'assets/svg/attendance.svg',
                            onTap: () => Get.to(() => const AttendenceScreen()),
                          ),
                          CustomBox(
                            title: 'Flight Comm',
                            iconPath: 'assets/svg/flight.svg',
                            onTap: () {},
                          ),
                          CustomBox(
                            title: 'My Roster',
                            iconPath: 'assets/svg/user.svg',
                            onTap: () {},
                          ),
                          CustomBox(
                            title: 'PTS',
                            iconPath: 'assets/svg/flight2.svg',
                            onTap: () {},
                          ),
                          CustomBox(
                            title: 'Leave Request',
                            iconPath: 'assets/svg/leave.svg',
                            onTap: () => Get.to(() => const LeaveRequestScreen()),
                          ),
                        ],
                      ),
                    ],
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
