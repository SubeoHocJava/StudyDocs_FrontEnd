import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../data/model/global/api_response.dart';
import '../constants/api_constants.dart';
import '../exceptions/api_exception.dart';
import 'package:studydocs/features/auth/data/keycloak_auth_service.dart';

import 'intercepter.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio _dio;
  ApiInterceptor? _apiInterceptor;

  factory DioClient() {
    return _instance ??= DioClient._internal();
  }

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logging (chỉ dùng trong development)
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, error: true),
      );
    }
  }

  Dio get dio => _dio;

  void configureAuth({
    required KeycloakAuthService keycloakAuth,
    void Function()? onSessionExpired,
  }) {
    if (_apiInterceptor != null) {
      _dio.interceptors.remove(_apiInterceptor!);
    }
    _apiInterceptor = ApiInterceptor(
      keycloakAuth: keycloakAuth,
      onSessionExpired: onSessionExpired,
      retryDio: _dio,
    );
    _dio.interceptors.insert(0, _apiInterceptor!);
  }

  // Helper methods
  Future<ApiResponse<dynamic>> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      return fromResponse<dynamic>(
        await _dio.get(path, queryParameters: queryParameters),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<dynamic>> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      return fromResponse<dynamic>(
        await _dio.post(path, data: data, queryParameters: queryParameters),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<dynamic>> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      return fromResponse<dynamic>(
        await _dio.put(path, data: data, queryParameters: queryParameters),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }



  Future<ApiResponse<dynamic>> patch(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      return fromResponse<dynamic>(
        await _dio.patch(path, data: data, queryParameters: queryParameters),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<dynamic>> delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      return fromResponse<dynamic>(
        await _dio.delete(path, data: data, queryParameters: queryParameters),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final responseData = error.response?.data;

        // Parse error message từ backend (format: {message: "..."} hoặc {errorMessage: "..."})
        String message = 'Có lỗi xảy ra từ server';
        String? errorCode;
        if (responseData is Map<String, dynamic>) {
          message = responseData['message'] ??
              responseData['errorMessage'] ??
              message;
          errorCode = responseData['errorCode']?.toString();
        }

        // Phân biệt Auth errors (401, 403)
        if (statusCode == 401 || statusCode == 403) {
          return AuthException(message, statusCode, code: errorCode);
        }

        return ServerException(message, statusCode, code: errorCode);

      case DioExceptionType.cancel:
        return ApiException('Request đã bị hủy', code: 'REQUEST_CANCELLED');

      default:
        return NetworkException('Lỗi kết nối: ${error.message ?? "Unknown error"}');
    }
  }

  Future<ApiResponse<T>> fromResponse<T>(Response response) async {
    dynamic responseData = response.data;
    // 🔥 DELETE / 204 No Content
    if (responseData == null ||
        (responseData is String && responseData.trim().isEmpty)) {
      return ApiResponse<T>(
        statusCode: response.statusCode ?? 200,
        data: null,
        errorCode: null,
      );
    }
    if (responseData is String) {
      responseData = jsonDecode(responseData);
    }
    return ApiResponse<T>.fromJson(responseData, null);
  }
}