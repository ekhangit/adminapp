import 'package:sp_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/auth/login_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.backgroundColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          title: const Text(
            "Login",
            style: TextStyle(color: AppColors.appBarTextColor),
          ),
          centerTitle: false,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios, color: AppColors.appBarTextColor),
          ),
        ),
        body: Stack(
          children: [
            Obx(
              () => IgnorePointer(
                ignoring: controller.isLoading.value,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    // top: 70.0,
                    bottom: 150.0,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/logo_gsrm.png", height: 100),

                        const SizedBox(height: 30),

                        // Email Field
                        Obx(
                          () => CustomTextField(
                            hintText: "Email",
                            errorText:
                                controller.emailError.value
                                    ? 'Required Field!'
                                    : null,
                            onChanged: (value) {
                              controller.email.value = value;
                            },
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Password Field
                        Obx(
                          () => CustomTextField(
                            hintText: "Password",
                            errorText:
                                controller.passwordError.value
                                    ? 'Required Field!'
                                    : null,
                            obscureText: controller.passwordObscure.value,
                            isPasswordField: true,
                            onChanged: (value) {
                              controller.password.value = value;
                            },
                            onShow: () => controller.obscureChanged(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Login Button
                        Obx(
                          () => CustomButton(
                            text: "Continue",
                            onPressed: () => controller.login(),
                            color: AppColors.buttonColor1,
                            disabled: !controller.canContinue,
                            // isLoading: controller.isLoading.value,
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 🧊 Loading Overlay
            Obx(() {
              return controller.isLoading.value
                  ? Container(
                    color: Colors.white.withValues(alpha: 0.50),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: kElevationToShadow[1],
                          border: Border.all(
                            color: AppColors.matteBlackColor,
                            width: 0.05,
                          ),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: AppColors.colorPrimary,
                          ),
                        ),
                      ),
                    ),
                  )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
