import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constant.dart';
import '../controllers/storage/data_storage_controller.dart';

class BaseService extends GetxService {
  late Dio _dio;
  static BaseService get instance => Get.find<BaseService>();

  void reloadHeaders() async {
    String authToken = await _fetchAuthToken();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['authuid'] = authToken;
          // options.headers['authid'] = apiKey;
          return handler.next(options);
        },
      ),
    );
  }

  Future<BaseService> init() async {
    // log("[BaseService] init");
    // Simulate fetching tokens and device info
    String authToken = await _fetchAuthToken();
    String deviceUniqueId;
    String deviceModel;

    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // if (Platform.isIOS) {
    //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //   deviceUniqueId = iosInfo.identifierForVendor!; // Unique ID on iOS
    //   deviceModel = iosInfo.utsname.machine; // iPhone model
    // } else {
    //   // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //   // deviceUniqueId = androidInfo.serialNumber; // Unique ID on Android
    //   // deviceModel = androidInfo.model; // Android device model
    //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //   // deviceUniqueId = androidInfo.serialNumber;

    //   AndroidId androidIdPlugin = const AndroidId();
    //   deviceUniqueId = await androidIdPlugin.getId() ?? 'Unknown ID';
    //   deviceModel = androidInfo.model; // Android device model
    // }

    _dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 30000),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // options.headers['device-unique-id'] = deviceUniqueId;
          // options.headers['phoneModel'] = deviceModel;
          // options.headers['appVersion'] = packageInfo.version;
          options.headers['authuid'] = authToken;
          // options.headers['authuid'] = "1b20571192cadeedbfee91c37554e0810caaf1d04db0e1146aec64584c32be60e8a1122971914dd0af9d82e9cf810fdb8a7c4e9ee6b7c9bffae6d707a1edc18e";
          // options.headers['authid'] = apiKey;
          return handler.next(options); // Continue with the requestw
        },
        onResponse: (response, handler) {
          return handler.next(response); // Continue with the response
        },
        onError: (DioError e, handler) {
          return handler.next(e); // Continue with the error
        },
      ),
    );

    // print("[apiurl] ${dio.options.baseUrl}");

    return this;
  }

  Dio get dio => _dio;

  Future<String> _fetchAuthToken() async {
    String token = await DataStorageController.to.fetchAuthToken();
    // log('[Token] $token');
    return token;
  }
}
