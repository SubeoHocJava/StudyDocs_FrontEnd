import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../data/model/global/api_response.dart';
import '../../screens/auth/data/auth_service.dart';
import '../constants/api_constants.dart';
import '../error/error_mapper.dart';
import '../exceptions/api_exception.dart';


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
    required AuthService authService,
    void Function()? onSessionExpired,
  }) {
    if (_apiInterceptor != null) {
      _dio.interceptors.remove(_apiInterceptor!);
    }
    _apiInterceptor = ApiInterceptor(
      authService: authService,
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
      return await fromResponse<dynamic>(
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
        Options? options,
      }) async {
    try {
      return await fromResponse<dynamic>(
        await _dio.post(path, data: data, queryParameters: queryParameters, options: options),
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
      return await fromResponse<dynamic>(
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
      return await fromResponse<dynamic>(
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
      return await fromResponse<dynamic>(
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
        return NetworkException(
          ErrorMapper.map('NETWORK_ERROR'),
          code: 'NETWORK_ERROR',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final parsed = _parseErrorBody(error.response?.data);
        final errorCode = parsed.errorCode;
        final mappedMessage = ErrorMapper.map(errorCode, defaultMessage: parsed.message);

        if (statusCode == 401 || statusCode == 403) {
          return AuthException(mappedMessage, statusCode, code: errorCode);
        }

        return ServerException(mappedMessage, statusCode, code: errorCode);

      case DioExceptionType.cancel:
        return ApiException(
          ErrorMapper.map('REQUEST_CANCELLED'),
          code: 'REQUEST_CANCELLED',
        );

      default:
        return NetworkException(
          ErrorMapper.map('NETWORK_ERROR', defaultMessage: error.message),
          code: 'NETWORK_ERROR',
        );
    }
  }

  ({String message, String? errorCode}) _parseErrorBody(dynamic responseData) {
    const fallback = 'Có lỗi xảy ra từ server';
    if (responseData == null) {
      return (message: fallback, errorCode: null);
    }

    Map<String, dynamic>? map;
    if (responseData is Map<String, dynamic>) {
      map = responseData;
    } else if (responseData is Map) {
      map = Map<String, dynamic>.from(responseData);
    } else if (responseData is String && responseData.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(responseData);
        if (decoded is Map) {
          map = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }

    if (map == null) {
      return (message: responseData.toString(), errorCode: null);
    }

    final nested = map['data'];
    final nestedMap =
        nested is Map ? Map<String, dynamic>.from(nested) : null;

    final message = map['message']?.toString() ??
        map['errorMessage']?.toString() ??
        nestedMap?['message']?.toString() ??
        fallback;

    final errorCode =
        map['errorCode']?.toString() ?? nestedMap?['errorCode']?.toString();

    return (message: message, errorCode: errorCode);
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
    
    // Check if response is raw/unwrapped (does not contain 'statusCode' at the root level)
    if (responseData is Map && !responseData.containsKey('statusCode')) {
      return ApiResponse<T>(
        statusCode: response.statusCode ?? 200,
        data: responseData as T,
        errorCode: null,
      );
    } else if (responseData is List) {
      return ApiResponse<T>(
        statusCode: response.statusCode ?? 200,
        data: responseData as T,
        errorCode: null,
      );
    }

    return ApiResponse<T>.fromJson(Map<String, dynamic>.from(responseData), null);
  }
}