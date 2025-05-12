import 'package:aviation_app/utils/app_colors.dart';
import 'package:aviation_app/screens/main_screen.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';
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
      final response = await AuthService.instance.login(
        email: email.value,
        password: password.value,
        deviceType: "android", // or "ios"
        deviceToken: "your_device_token_here", // get from FCM ideally
      );

      if (response.isSuccess) {
        // Access full response data (including token/user if needed)
        final data = response.data!;
        // final user = UserModel.fromMap(data['user']); 


        Get.offAll(() => MainScreen());

        Utils.showFlushbar(
          Get.context!,
          "Login Successfully.",
          backgroundColor: AppColors.colorSuccess,
        );
      } else {
        Utils.showFlushbar(
          Get.context!,
          "Login failed",
          backgroundColor: AppColors.colorWarning,
        );
      }
    } catch (e) {
      Utils.showFlushbar(
        Get.context!,
        "Something went wrong",
        backgroundColor: AppColors.colorWarning,
      );
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
