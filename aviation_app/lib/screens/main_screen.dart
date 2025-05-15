import 'package:aviation_app/utils/app_colors.dart';
import 'package:aviation_app/controllers/NavigationController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Navigationcontroller controller = Get.put(Navigationcontroller());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color.fromARGB(255, 78, 135, 179),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => NavigationBar(
            backgroundColor: Color.fromARGB(255, 78, 135, 179),
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected:
                (index) => controller.selectedIndex.value = index,
            indicatorColor: Colors.transparent,
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
              states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                  color: AppColors.colorWhite,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                );
              }
              return TextStyle(
                // color: Colors.black38,
                color: Colors.grey.shade400,
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
              );
            }),
            destinations: [
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/svg/home.svg',
                  width: 30,
                  height: 30,
                  color:
                      controller.selectedIndex.value == 0
                          ? AppColors.colorWhite
                          : Colors.grey.shade400,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/svg/notification.svg',
                  width: 30,
                  height: 30,
                  color:
                      controller.selectedIndex.value == 1
                          ? AppColors.colorWhite
                          : Colors.grey.shade400,
                ),
                label: 'Notification',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/svg/about.svg',
                  width: 30,
                  height: 30,
                  color:
                      controller.selectedIndex.value == 2
                          ? AppColors.colorWhite
                          : Colors.grey.shade400,
                ),
                label: 'About',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/svg/user.svg',
                  width: 30,
                  height: 30,
                  color:
                      controller.selectedIndex.value == 3
                          ? AppColors.colorWhite
                          : Colors.grey.shade400,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),

        body: Obx(() => controller.screens[controller.selectedIndex.value]),
      ),
    );
  }
}
