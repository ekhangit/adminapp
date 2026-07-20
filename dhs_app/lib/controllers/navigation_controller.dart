import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/dashboard/dashboard_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/profile/profile_screen.dart';
import 'storage/data_storage_controller.dart';

class Navigationcontroller extends GetxController {
  static Navigationcontroller instance = Get.find();
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch employee profile as soon as the main screen loads.
    DataStorageController.to.loadEmpProfile();
  }

  final screens = [
    DashboardScreen(),
    const NotificationScreen(),
    Container(),
    ProfileScreen(),
  ];
}
