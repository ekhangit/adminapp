import 'package:flutter/material.dart';

import 'package:gsrm_live_app/utils/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/auth/signup_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

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
            "SignUp",
            style: TextStyle(color: AppColors.appBarTextColor),
          ),
          centerTitle: false,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios, color: AppColors.appBarTextColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
          child: Column(
            children: [
              // Name Field
              Obx(
                () => CustomTextField(
                  hintText: "Name",
                  errorText:
                      controller.nameError.value ? 'Required Field!' : null,
                  onChanged: (value) {
                    controller.name.value = value;
                  },
                ),
              ),
              const SizedBox(height: 15),

              // Email Field
              Obx(
                () => CustomTextField(
                  hintText: "Email",
                  errorText:
                      controller.emailError.value ? 'Required Field!' : null,
                  onChanged: (value) {
                    controller.email.value = value;
                  },
                ),
              ),
              const SizedBox(height: 15),

              Divider(),

              const SizedBox(height: 15),

              // Password Field
              Obx(
                () => CustomTextField(
                  hintText: "Password",
                  errorText:
                      controller.passwordError.value ? 'Required Field!' : null,
                  obscureText: true,
                  onChanged: (value) {
                    controller.password.value = value;
                  },
                ),
              ),
              const SizedBox(height: 15),

              // Password Field
              Obx(
                () => CustomTextField(
                  hintText: "Confirm Password",
                  errorText:
                      controller.passwordError.value ? 'Required Field!' : null,
                  obscureText: true,
                  onChanged: (value) {
                    controller.cpassword.value = value;
                  },
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.colorPrimary,
                      size: 17.5,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Password must be at least 8 characters long",
                      style: TextStyle(
                        color: AppColors.lightGreyTextColor,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // Login Button
              Obx(
                () => CustomButton(
                  text: "Continue",
                  onPressed: () => controller.signup(),
                  color: AppColors.buttonColor1,
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

              // const SizedBox(height: 30),

              // RichText(
              //   text: TextSpan(
              //     text: "You Have an account? ",
              //     style: TextStyle(color: Colors.black54),
              //     children: [
              //       TextSpan(
              //         text: 'Sign In',
              //         style: TextStyle(color: AppColors.colorPrimary),

              //         recognizer:
              //             TapGestureRecognizer()
              //               ..onTap = () {
              //                 Get.off(() => const LoginScreen());
              //               },
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
