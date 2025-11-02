import 'package:sp_app/screens/auth/login_screen.dart';
// import 'package:sp_app/screens/auth/welcome_screen.dart';
import 'package:get/get.dart';

import '../screens/main_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/', page: () => LoginScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/main', page: () => MainScreen()),
  ];
}
