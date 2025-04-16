import 'dart:developer';

import 'package:aviation_app/screens/attendance/widget/check_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/attendance/attendance_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_box.dart';
import '../../widgets/custom_image.dart';

class AttendenceScreen extends StatelessWidget {
  const AttendenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.put(AttendanceController());

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
                            print("Back tapped");
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
                          CustomCircularImage(
                            imageUrl:
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKt_6sESyf8bB3iEbzv_4cXGUIuUUSOQRstX03bwqEZFRcwdmBQQTtdrDUSy-NST0sMxo&usqp=CAU',
                            isNetwork: true,
                            borderColor: Colors.white,
                            size: 60.0,
                          ),
                          SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Mr. Muhammad Haseeb",
                                style: TextStyle(
                                  color: AppColors.colorSecondary.withOpacity(
                                    0.75,
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
                const SizedBox(height: 200), // Offset to clear top container
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
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.currentDate.value,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
                          onTap: () async {
                            final success =
                                await controller.handleBiometricClockAction();
                            if (!success) {
                              ScaffoldMessenger.of(Get.context!).showSnackBar(
                                const SnackBar(
                                  content: Text('Authentication failed'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                // const SizedBox(height: 30),
                // Container(
                //   padding: const EdgeInsets.all(16.0),

                //   margin: EdgeInsets.symmetric(horizontal: 32.0),
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(12.0),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,

                //           children: [
                //             Text(
                //               "Attendance",
                //               style: TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),

                //             Text(
                //               "Current Month",
                //               style: TextStyle(
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.bold,
                //                 color: AppColors.lightGreyTextColor,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       const SizedBox(height: 10),
                // Wrap(
                //   spacing: 16,
                //   runSpacing: 16,
                //   children: [
                //     CustomArrowBox(
                //       title: 'Early Leave',
                //       count: '08',
                //       color: Color(0xFF2c7fb8),
                //       onTap: () {},
                //     ),
                //     CustomArrowBox(
                //       title: 'Absent',
                //       count: '08',

                //       color: Color(0xFF6b5de8),
                //       onTap: () {},
                //     ),
                //     CustomArrowBox(
                //       title: 'Late In',
                //       count: '08',

                //       color: Color(0xFFe54e1f),
                //       onTap: () {},
                //     ),
                //     CustomArrowBox(
                //       title: 'Total Leaves',
                //       count: '08',

                //       color: Color(0xFFef8c18),
                //       onTap: () {},
                //     ),
                //   ],
                // ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
