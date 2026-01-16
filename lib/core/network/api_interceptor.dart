import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../services/token_storage_service.dart';

class ApiInterceptor extends QueuedInterceptor {
  final TokenStorageService _tokenStorage;

  ApiInterceptor({TokenStorageService? tokenStorage})
    : _tokenStorage = tokenStorage ?? TokenStorageService();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Danh sách các path không cần gửi kèm token (Public Endpoints)
    const publicPaths = [
      '/auth/login/local',
      '/auth/login/provider/google',
      '/auth/register/local',
      '/internal', //  Cho phép tất cả các API internal đi xuyên (không cần token)
    ];

    final isPublic = publicPaths.any((path) => options.path.contains(path));

    if (!isPublic) {
      // Tự động thêm token vào header nếu có và KHÔNG phải public endpoint
      final authHeader = await _tokenStorage.getAuthorizationHeader();
      if (authHeader != null) {
        options.headers['Authorization'] = authHeader;
      }
    }

    if (kDebugMode) {
      print('REQUEST[${options.method}] => PATH: ${options.path}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('ERROR[${err.response?.statusCode}] => MESSAGE: ${err.message}');
    }
    super.onError(err, handler);
  }
}
