import 'package:aviation_app/screens/attendance/attendence_screen.dart';
import 'package:aviation_app/screens/flightcomm/flightcomm_screen.dart';
import 'package:aviation_app/screens/leave/leave_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constant.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_box.dart';

// concept one (DashboardScreenTwo) is used in the navigation controller

// class DashboardScreenTwo extends StatelessWidget {
//   const DashboardScreenTwo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final randomColor = getRandomColor();
//     const initials = "JF";

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: SafeArea(
//         child: Container(
//           color: AppColors.backgroundColor,
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 10.0,
//                   horizontal: 20.0,
//                 ),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 24,
//                       backgroundColor: randomColor.withOpacity(0.2),
//                       child: Text(
//                         initials,
//                         style: TextStyle(
//                           color: randomColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 15.0),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "James Faulkner",
//                           style: TextStyle(
//                             color: AppColors.matteBlackColor,
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Text(
//                           "Munich",
//                           style: TextStyle(
//                             color: AppColors.matteBlackColor,
//                             fontSize: 14.0,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                     CircleAvatar(
//                       radius: 24,
//                       backgroundColor: AppColors.colorPrimary.withOpacity(0.2),
//                       child: Icon(
//                         Icons.notifications,
//                         color: AppColors.colorPrimary,
//                         size: 28,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Divider(thickness: 0.25),

//               SizedBox(height: 12),

//               // ⚪ White content starting after the top, but height wraps content
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Wrap(
//                     spacing: 12,
//                     children: [
//                       CustomBox2(
//                         title: 'Attendance',
//                         iconPath: 'assets/svg/attendance_new.svg',
//                         onTap: () => Get.to(() => const AttendenceScreen()),
//                       ),
//                       CustomBox2(
//                         title: 'Flight Comm',
//                         iconPath: 'assets/svg/flight_comm.svg',
//                         onTap: () => Get.to(() => const FlightcommScreen()),
//                       ),
//                       CustomBox2(
//                         title: 'My Roster',
//                         iconPath: 'assets/svg/my_roster.svg',
//                         onTap: () {},
//                       ),
//                       CustomBox2(
//                         title: 'PTS',
//                         iconPath: 'assets/svg/pts.svg',
//                         onTap: () {},
//                       ),
//                       CustomBox2(
//                         title: 'Leave Request',
//                         iconPath: 'assets/svg/leave.svg',
//                         onTap: () => Get.to(() => const LeaveRequestScreen()),
//                       ),
//                       CustomBox2(
//                         title: 'Staff Watch',
//                         iconPath: 'assets/svg/staff_watch.svg',
//                         onTap: () {},
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// concept two (DashboardScreenTwo) is used in the navigation controller

class DashboardScreenTwo extends StatelessWidget {
  const DashboardScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final randomColor = getRandomColor();
    const initials = "JF";

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.colorWhite,
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Container(
          color: AppColors.colorPrimary.withOpacity(0.95),
          child: Column(
            children: [
              Container(
                color: AppColors.colorWhite,
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.colorPrimary.withOpacity(0.2),
                      child: Text(
                        initials,
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
                      children: [
                        Text(
                          "James Faulkner",
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

              // Divider(thickness: 0.25, color: AppColors.lightGreyTextColor),
              SizedBox(height: 16),

              // ⚪ White content starting after the top, but height wraps content
              Expanded(
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
                            iconPath: 'assets/svg/attendance_new.svg',
                            onTap: () => Get.to(() => const AttendenceScreen()),
                          ),
                          CustomBox2(
                            title: 'Flight Comm',
                            iconPath: 'assets/svg/flight_comm.svg',
                            onTap: () => Get.to(() => const FlightcommScreen()),
                          ),
                          CustomBox2(
                            title: 'My Roster',
                            iconPath: 'assets/svg/my_roster.svg',
                            onTap: () {},
                          ),
                          CustomBox2(
                            title: 'PTS',
                            iconPath: 'assets/svg/pts.svg',
                            onTap: () {},
                          ),
                          CustomBox2(
                            title: 'Leave Request',
                            iconPath: 'assets/svg/leave.svg',
                            onTap:
                                () => Get.to(() => const LeaveRequestScreen()),
                          ),
                          CustomBox2(
                            title: 'Staff Watch',
                            iconPath: 'assets/svg/staff_watch.svg',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
