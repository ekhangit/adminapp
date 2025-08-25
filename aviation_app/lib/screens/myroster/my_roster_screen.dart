import 'package:aviation_app/screens/myroster/tabs/custom_roster_tab.dart';
import 'package:aviation_app/screens/myroster/tabs/monthly_roster_tab.dart';
import 'package:aviation_app/screens/myroster/tabs/today_roster_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/myroster/my_roster_controller.dart';
import '../../utils/app_colors.dart';

class MyRosterScreen extends StatelessWidget {
  MyRosterScreen({super.key});

  final controller = Get.put(MyRosterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Roster",
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.colorPrimary,
        actions: [
          Obx(
            () =>
                controller.selectedDuties.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {},
                    )
                    : const SizedBox(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tab Buttons
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _buildTabButton('Today', 0)),
                  const SizedBox(width: 4),
                  Expanded(child: _buildTabButton('Monthly', 1)),
                  const SizedBox(width: 4),
                  Expanded(child: _buildTabButton('Custom', 2)),
                ],
              ),
            ),

            // View switcher
            Obx(() {
              switch (controller.selectedTabIndex.value) {
                case 0:
                  return const TodayRosterTab();
                case 1:
                  return const MonthlyRosterTab();
                case 2:
                  return const CustomRosterTab();
                default:
                  return const TodayRosterTab();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectedTabIndex.value = index,
        child: Container(
          decoration: BoxDecoration(
            color:
                controller.selectedTabIndex.value == index
                    ? AppColors.colorPrimary
                    : Colors.grey[100],
            borderRadius: BorderRadius.circular(25.0),
            boxShadow:
                controller.selectedTabIndex.value == index
                    ? [
                      BoxShadow(
                        color: AppColors.colorPrimary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      controller.selectedTabIndex.value == index
                          ? Colors.white
                          : Colors.grey[700],
                  fontWeight:
                      controller.selectedTabIndex.value == index
                          ? FontWeight.bold
                          : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
