import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:studydocs/data/model/api_response.dart';
import '../constants/api_constants.dart';
import 'api_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConstants.baseUrl,
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
  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return fromResponse(
        await _dio.get(path, queryParameters: queryParameters),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return fromResponse(
        await _dio.post(path, data: data, queryParameters: queryParameters),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return fromResponse(
        await _dio.put(path, data: data, queryParameters: queryParameters),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return fromResponse(
        await _dio.patch(path, data: data, queryParameters: queryParameters),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  Future<ApiResponse> delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      return fromResponse(
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

  Future<ApiResponse> fromResponse(Response response) async {
    dynamic responseData = response.data;
    if (responseData is String) {
      responseData = jsonDecode(responseData);
    }
    return ApiResponse.fromJson(responseData);
  }
}
