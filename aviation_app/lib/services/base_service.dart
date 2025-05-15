import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constant.dart';
import '../controllers/storage/data_storage_controller.dart';

// class BaseService extends GetxService {
//   late Dio _dio;
//   static BaseService get instance => Get.find<BaseService>();

//   void reloadHeaders() async {
//     String authToken = await _fetchAuthToken();

//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           return handler.next(options);
//         },
//       ),
//     );
//   }

//   Future<BaseService> init() async {

//     String authToken = await _fetchAuthToken();

//     _dio = Dio(
//       BaseOptions(
//         baseUrl: apiUrl,
//         connectTimeout: const Duration(milliseconds: 10000),
//         receiveTimeout: const Duration(milliseconds: 30000),
//       ),
//     );

//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {

//           return handler.next(options); // Continue with the requestw
//         },
//         onResponse: (response, handler) {
//           return handler.next(response); // Continue with the response
//         },
//         onError: (DioError e, handler) {
//           return handler.next(e); // Continue with the error
//         },
//       ),
//     );

//     // print("[apiurl] ${dio.options.baseUrl}");

//     return this;
//   }

//   Dio get dio => _dio;

//   Future<String> _fetchAuthToken() async {
//     String token = await DataStorageController.to.fetchAuthToken();
//     log('[fetchAuthToken] toke : $token');
//     return token;
//   }
// }

class BaseService extends GetxService {
  late Dio _dio;
  static BaseService get instance => Get.find<BaseService>();

  void reloadHeaders() {
    _dio.interceptors.clear(); // Remove old interceptors

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await DataStorageController.to.fetchAuthToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  /// Initialize Dio and setup interceptor
  Future<BaseService> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await DataStorageController.to.fetchAuthToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            log('[BaseService] Token added: $token');
          } else {
            log('[BaseService] No auth token found');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (DioException e, handler) => handler.next(e),
      ),
    );

    return this;
  }

  Dio get dio => _dio;
}
