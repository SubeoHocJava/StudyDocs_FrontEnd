import 'package:dio/dio.dart';
import '../utils/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final ITokenStorage tokenStorage;
  final Dio dio;

  AuthInterceptor({required this.tokenStorage, required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // 1. Check if we have a refresh token
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          // 2. Call Keycloak refresh token API
          // final response = await dio.post('KEYCLOAK_REFRESH_URL', data: {'refresh_token': refreshToken, ...});
          // final newAccessToken = response.data['access_token'];
          // final newRefreshToken = response.data['refresh_token'];
          
          // 3. Save new tokens
          // await tokenStorage.saveTokens(accessToken: newAccessToken, refreshToken: newRefreshToken);
          
          // 4. Retry the failed request
          // err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          // final retryResponse = await dio.fetch(err.requestOptions);
          // return handler.resolve(retryResponse);
        } catch (e) {
          // Refresh failed, probably token expired, clear tokens and let the error propagate
          await tokenStorage.clearTokens();
        }
      }
    }
    super.onError(err, handler);
  }
}
