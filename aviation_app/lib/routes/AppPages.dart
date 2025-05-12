import 'package:aviation_app/screens/auth/login_screen.dart';
import 'package:aviation_app/screens/auth/welcome_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/', page: () => WelcomeScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
  ];
}
