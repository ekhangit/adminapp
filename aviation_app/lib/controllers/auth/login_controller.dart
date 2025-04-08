import 'package:aviation_app/utils/app_colors.dart';
import 'package:aviation_app/screens/main_screen.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

class LoginController extends GetxController {
  static LoginController instance = Get.find();

  RxBool emailError = false.obs;
  RxBool passwordError = false.obs;

  var email = ''.obs;
  var password = ''.obs;

  var isLoading = false.obs;
  var passwordObscure = true.obs;

  void obscureChanged() {
    passwordObscure.value = !passwordObscure.value;
  }

  bool get canContinue => email.value.isNotEmpty && password.value.isNotEmpty;

  /// **🔹 Login Function**
  Future<void> login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      emailError.value = email.value.isEmpty;
      passwordError.value = password.value.isEmpty;
      Utils.showSnackbar("Error", "All fields are required");
      return;
    }
    emailError.value = false;
    passwordError.value = false;

    _setLoading(true);
    try {
      await Future.wait([
        Future.delayed(const Duration(seconds: 3)), // Minimum loading duration
        Future(() async {
          // Simulate login logic
          if (email.value == 'admin' && password.value == 'admin') {
            Get.offAll(() => MainScreen());

            Utils.showFlushbar(
              Get.context!,
              "Login Successfully.",
              backgroundColor: AppColors.buttonColor2,
            );
          } else {
            Utils.showFlushbar(
              Get.context!,
              "These credentials do not match our record.",
              backgroundColor: AppColors.colorWarning,
            );
          }
        }),
      ]);
    } finally {
      _setLoading(false);
    }
  }

  /// **🔹 Set Loading State with Animation**
  void _setLoading(bool state) {
    isLoading.value = state;
    if (state) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (isLoading.value) isLoading.value = false;
      });
    }
  }
}
