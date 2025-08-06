import 'package:dhs_app/constant.dart';
import 'package:dhs_app/controllers/storage/data_storage_controller.dart';
import 'package:dhs_app/firebase_options.dart';
import 'package:dhs_app/routes/AppPages.dart';
import 'package:dhs_app/services/base_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  removeSplash();

  await Get.putAsync(() async => DataStorageController(), permanent: true);
  await Get.putAsync(() async => BaseService().init(), permanent: true);
  final authToken = await DataStorageController.to.fetchAuthToken();

  print("MyApp Login bool: $authToken");

  runApp(MyApp(isLoggedIn: authToken.isNotEmpty));
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
    print("MyApp Login Status: $isLoggedIn");

    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          navigatorKey: Get.key,
          title: appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: fontFamily),
          initialRoute: isLoggedIn ? '/main' : '/login',
          getPages: AppPages.routes,
        );
      },
    );
  }
}
