import 'package:aviation_app/screens/home/home_screen.dart';
import 'package:get/get.dart';

import '../screens/dashboard/dashboard_screen.dart';

class Navigationcontroller extends GetxController {
  static Navigationcontroller instance = Get.find();
  final selectedIndex = 0.obs;

  final screens = [DashboardScreen(), HomeScreen()];
}
