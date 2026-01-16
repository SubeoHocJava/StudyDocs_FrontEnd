import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:studydocs/data/model/api_response.dart';
import '../constants/api_constants.dart';
import '../exceptions/api_exception.dart';
import 'api_interceptor.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio _dio;

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

    // Add interceptors
    _dio.interceptors.add(ApiInterceptor());

    // Logging (chỉ dùng trong development)
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, error: true),
      );
    }
  }

  Dio get dio => _dio;

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
        if (responseData is Map<String, dynamic>) {
          message = responseData['message'] ?? 
                    responseData['errorMessage'] ?? 
                    message;
        }
        
        // Phân biệt Auth errors (401, 403)
        if (statusCode == 401 || statusCode == 403) {
          return AuthException(message, statusCode);
        }
        
        return ServerException(message, statusCode);
        
      case DioExceptionType.cancel:
        return ApiException('Request đã bị hủy', code: 'REQUEST_CANCELLED');
        
      default:
        return NetworkException('Lỗi kết nối: ${error.message ?? "Unknown error"}');
    }
  }

  Future<ApiResponse<T>> fromResponse<T>(Response response) async {
    dynamic responseData = response.data;
    if (responseData is String) {
      responseData = jsonDecode(responseData);
    }
    return ApiResponse<T>.fromJson(responseData, null);
  }
}
