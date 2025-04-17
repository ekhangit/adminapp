import 'package:aviation_app/screens/auth/welcome_screen.dart';
import 'package:aviation_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  removeSplash();

  runApp(const MyApp());
}

Future removeSplash() async {
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Aviation',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(fontFamily: 'Saira'),
      home: const MainScreen(),
    );
  }
}
