import 'package:aviation_app/constant.dart';
import 'package:aviation_app/controllers/storage/data_storage_controller.dart';
import 'package:aviation_app/routes/AppPages.dart';
import 'package:aviation_app/screens/main_screen.dart';
import 'package:aviation_app/services/base_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  removeSplash();

  await Get.putAsync(() async => DataStorageController(), permanent: true);
  await Get.putAsync(() async => BaseService().init(), permanent: true);
  bool isLoggedIn = DataStorageController.to.currentSession.value != null;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future removeSplash() async {
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          navigatorKey: Get.key,
          title: appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: fontFamily),
          // home: const MainScreen(),
          getPages: AppPages.routes,
        );
      },
    );
  }
}
