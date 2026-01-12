import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:studydocs/data/model/api_response.dart';
import '../constants/api_constants.dart';
import 'api_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
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
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
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
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        return Exception('Server error: ${error.response?.statusCode}');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error: ${error.message}');
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
