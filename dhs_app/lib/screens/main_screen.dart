import 'package:dhs_app/utils/app_colors.dart';
import 'package:dhs_app/controllers/navigation_controller.dart';
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
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => NavigationBar(
            // backgroundColor: Color.fromARGB(255, 78, 135, 179),
            backgroundColor: Colors.white,
            height: 68,
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
                  color: AppColors.colorPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                );
              }
              return TextStyle(
                // color: Colors.black38,
                color: Colors.grey.shade400,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              );
            }),
            destinations: [
              NavigationDestination(
                icon: AnimatedScale(
                  scale: controller.selectedIndex.value == 0 ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  child: SvgPicture.asset(
                    'assets/svg/home.svg',
                    width: 24,
                    height: 24,
                    color:
                        controller.selectedIndex.value == 0
                            ? AppColors.colorPrimary
                            : Colors.grey.shade400,
                  ),
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: AnimatedScale(
                  scale: controller.selectedIndex.value == 1 ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  child: SvgPicture.asset(
                    'assets/svg/notification.svg',
                    width: 24,
                    height: 24,
                    color:
                        controller.selectedIndex.value == 1
                            ? AppColors.colorPrimary
                            : Colors.grey.shade400,
                  ),
                ),
                label: 'Notification',
              ),
              NavigationDestination(
                icon: AnimatedScale(
                  scale: controller.selectedIndex.value == 2 ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  child: SvgPicture.asset(
                    'assets/svg/about.svg',
                    width: 24,
                    height: 24,
                    color:
                        controller.selectedIndex.value == 2
                            ? AppColors.colorPrimary
                            : Colors.grey.shade400,
                  ),
                ),
                label: 'About',
              ),
              NavigationDestination(
                icon: AnimatedScale(
                  scale: controller.selectedIndex.value == 3 ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  child: SvgPicture.asset(
                    'assets/svg/user.svg',
                    width: 24,
                    height: 24,
                    color:
                        controller.selectedIndex.value == 3
                            ? AppColors.colorPrimary
                            : Colors.grey.shade400,
                  ),
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
