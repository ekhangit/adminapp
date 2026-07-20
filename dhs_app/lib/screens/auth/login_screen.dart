import 'package:dhs_app/utils/app_colors.dart';
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
                        Image.asset("assets/images/logo_new.png", height: 70),

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
                        const SizedBox(height: 36),

                        // Login Button
                        Obx(
                          () => CustomButton(
                            text: "Sign In",
                            onPressed: () => controller.login(),
                            color: AppColors.buttonColor1,
                            borerRadius: 10,
                            disabled: !controller.canContinue,
                            isLoading: controller.isLoading.value,
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

            // 🔻 Footer: logo + copyright
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo_new.png', height: 20),
                    const SizedBox(height: 8),
                    Text(
                      '2026© All Rights Reserved',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
