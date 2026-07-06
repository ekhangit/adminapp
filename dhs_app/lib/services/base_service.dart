import 'dart:developer';

import 'package:dhs_app/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../constant.dart';
import '../controllers/storage/data_storage_controller.dart';
import '../utils/app_colors.dart';

class BaseService extends GetxService {
  late Dio _dio;
  static BaseService get instance => Get.find<BaseService>();

  /// 📤 Log outgoing request (method, url, headers, query, body)
  void _logRequest(RequestOptions options) {
    log('┌── [API REQUEST] ─────────────────────────────');
    log('│ ${options.method}  ${options.baseUrl}${options.path}');
    if (options.queryParameters.isNotEmpty) {
      log('│ Query : ${options.queryParameters}');
    }
    log('│ Headers: ${options.headers}');
    log('│ Body  : ${options.data}');
    log('└──────────────────────────────────────────────');
  }

  /// 📥 Log successful response (status, url, body)
  void _logResponse(Response response) {
    log('┌── [API RESPONSE] ${response.statusCode} ─────────────────');
    log('│ ${response.requestOptions.method}  ${response.requestOptions.uri}');
    log('│ Data  : ${response.data}');
    log('└──────────────────────────────────────────────');
  }

  /// ❌ Log error response (status, url, error body, message)
  void _logError(DioException e) {
    log('┌── [API ERROR] ${e.response?.statusCode ?? ''} ${e.type} ─────────');
    log('│ ${e.requestOptions.method}  ${e.requestOptions.uri}');
    log('│ Message: ${e.message}');
    log('│ Data   : ${e.response?.data}');
    log('└──────────────────────────────────────────────');
  }

  void reloadHeaders() {
    _dio.interceptors.clear(); // Remove old interceptors

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await DataStorageController.to.fetchAuthToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          _logRequest(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          _logError(e);
          log('[BaseService] onError : ${e.response?.statusCode}');

          if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
            log(
              '[BaseService] Auth error detected. Redirecting to LoginScreen.',
            );

            // Clear session
            await DataStorageController.to.clearSession();

            // Navigate to login screen
            Get.offAllNamed('/login');

            // Optionally show a message
            Utils.showFlushbar(
              Get.context!,
              "Session expired. Please log in again.",
              backgroundColor: AppColors.colorWarning,
            );
          }

          return handler.next(e);
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

          _logRequest(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          _logError(e);

          if (e.response?.statusCode == 302) {
            log(
              '[BaseService] Auth error detected. Redirecting to LoginScreen.',
            );

            // Clear session
            await DataStorageController.to.clearSession();

            // Navigate to login screen
            Get.offAllNamed('/login');

            // Optionally show a message
            Utils.showFlushbar(
              Get.context!,
              "Session expired. Please log in again.",
              backgroundColor: AppColors.colorWarning,
            );
          }

          return handler.next(e);
        },
      ),
    );

    return this;
  }

  Dio get dio => _dio;
}
