import 'package:sp_app/controllers/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Container(
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const Text(
          //   "Welcom to Home Screen",
          //   style: TextStyle(color: AppColors.matteBlackColor, fontSize: 20.0),
          // ),
          // const SizedBox(height: 20),

          // Logout Button
          CustomButton(
            text: "Logout",
            onPressed: () => controller.logout(),
            color: AppColors.buttonColor1,
            isLoading: false,
            loadingWidget: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
