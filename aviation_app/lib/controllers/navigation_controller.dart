import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/aboutus/about_us_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/profile/profile_screen.dart';

class Navigationcontroller extends GetxController {
  static Navigationcontroller instance = Get.find();
  final selectedIndex = 0.obs;

  final screens = [
    DashboardScreen(),
    Container(), // Notification screen placeholder
    AboutUsScreen(),
    ProfileScreen()
  ];
}
