import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../services/token_storage_service.dart';
import '../constants/api_constants.dart';

class ApiInterceptor extends QueuedInterceptor {
  final TokenStorageService _tokenStorage;
  // Dio riêng dùng để Refresh Token (tránh Interceptor loop)
  final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  ApiInterceptor({TokenStorageService? tokenStorage})
    : _tokenStorage = tokenStorage ?? TokenStorageService();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Danh sách các path không cần gửi kèm token (Public Endpoints)
    const publicPaths = [
      ApiConstants.authLoginLocal,
      ApiConstants.authLoginGoogle,
      ApiConstants.authRegister,
      '/internal', //  Cho phép tất cả các API internal đi xuyên
    ];

    final isPublic = publicPaths.any((path) => options.path.contains(path));

    // Logic kiểm tra và refresh token trước khi gửi request (Áp dụng cho Authenticated Enpoint)
    if (!isPublic) {
      bool isExpired = await _tokenStorage.isAccessTokenExpired();

      if (isExpired) {
        if (kDebugMode) {
          print(' AccessToken expired or near expiry. Attempting refresh...');
        }
        final refreshToken = await _tokenStorage.getRefreshToken();

        if (refreshToken != null) {
          try {
            // Gọi API Refresh Token
            final response = await _refreshDio.post(
              ApiConstants.authRefresh,
              data: {'refreshToken': refreshToken}, // Body params
            );

            if (response.statusCode == 200 && response.data != null) {
              final data = response.data['data'];
              if (data != null) {
                final newAccessToken = data['accessToken'];
                final newRefreshToken = data['refreshToken'];

                // Lưu token mới
                await _tokenStorage.saveTokens(
                  accessToken: newAccessToken,
                  refreshToken: newRefreshToken,
                  tokenType: data['tokenType'] ?? 'Bearer',
                  role:
                      await _tokenStorage.getRole() ??
                      'user', // Giữ nguyên role cũ nếu API ko trả về
                );

                if (kDebugMode) {
                  print('✅ Refresh Token Success. New AccessToken obtained.');
                }
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print('❌ Refresh Token Failed: $e');
            }
            // Nếu Refresh lỗi -> Xóa token và để request 401 tự nhiên (hoặc chuyển về Login tùy logic)
            // Ở đây mình cứ để request trôi đi, nó sẽ trả về 401 và UI sẽ handle logout sau
            // await _tokenStorage.clearTokens();
          }
        }
      }

      // Lấy lại AccessToken (có thể là mới hoặc cũ) để attach vào Header
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
