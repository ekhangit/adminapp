import 'package:sp_app/screens/auth/login_screen.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();

  /// **🔹 Logout Function**
  void logout() {
    Get.offAll(() => LoginScreen());
  }
}
