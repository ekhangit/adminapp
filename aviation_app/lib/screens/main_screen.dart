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
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.colorSecondary,
      ),
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => NavigationBar(
            backgroundColor: AppColors.colorSecondary,
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected:
                (index) => controller.selectedIndex.value = index,
            indicatorColor: Colors.transparent,
            labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((
              states,
            ) {
              if (states.contains(MaterialState.selected)) {
                return const TextStyle(
                  color: AppColors.colorPrimary,
                  fontWeight: FontWeight.w600,
                );
              }
              return const TextStyle(
                color: Colors.black38,
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
                          ? AppColors.colorPrimary
                          : Colors.black38,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/svg/flight.svg',
                  width: 30,
                  height: 30,
                  color:
                      controller.selectedIndex.value == 1
                          ? AppColors.colorPrimary
                          : Colors.black38,
                ),
                label: 'Flight',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/svg/chat.svg',
                  width: 30,
                  height: 30,
                  color:
                      controller.selectedIndex.value == 2
                          ? AppColors.colorPrimary
                          : Colors.black38,
                ),
                label: 'Chat',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/svg/user.svg',
                  width: 30,
                  height: 30,
                  color:
                      controller.selectedIndex.value == 3
                          ? AppColors.colorPrimary
                          : Colors.black38,
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
