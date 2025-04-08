import 'package:get/get.dart';

import '../../utils/utils.dart';

class SignupController extends GetxController {
  static SignupController instance = Get.find();

  RxBool nameError = false.obs;
  RxBool emailError = false.obs;
  RxBool passwordError = false.obs;
  RxBool cpasswordError = false.obs;

  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var cpassword = ''.obs;
  var isLoading = false.obs;

  /// **🔹 Login Function**
  Future<void> signup() async {
    if (name.value.isEmpty ||
        email.value.isEmpty ||
        password.value.isEmpty ||
        cpassword.value.isEmpty) {
      nameError.value = name.value.isEmpty;
      emailError.value = email.value.isEmpty;
      passwordError.value = password.value.isEmpty;
      cpasswordError.value = cpassword.value.isEmpty;

      Utils.showSnackbar("Error", "All fields are required");
      return;
    }
    nameError.value = false;
    emailError.value = false;
    passwordError.value = false;
    cpasswordError.value = false;

    _setLoading(true);
    try {} finally {
      _setLoading(false);
    }
  }


  bool get canContinue =>
    name.value.isNotEmpty &&
    email.value.isNotEmpty &&
    password.value.isNotEmpty &&
    cpassword.value.isNotEmpty;

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
