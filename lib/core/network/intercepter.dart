import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show VoidCallback, kDebugMode;
import 'package:studydocs/core/constants/api/auth_api.dart';
import 'package:studydocs/core/network/token_services.dart';


import '../../screens/auth/data/auth_service.dart';
import '../constants/api_constants.dart';

class ApiInterceptor extends QueuedInterceptor {
  static const _retryKey = 'auth_retry';

  final TokenStorageService _tokenStorage;
  final AuthService _authService;
  final VoidCallback? onSessionExpired;
  final Dio _retryDio;

  ApiInterceptor({
    TokenStorageService? tokenStorage,
    AuthService? authService,
    this.onSessionExpired,
    Dio? retryDio,
  })  : _tokenStorage = tokenStorage ?? TokenStorageService(),
        _authService = authService ?? AuthService(),
        _retryDio = retryDio ?? Dio();

  static const _publicPaths = [
    AuthApiEndpoints.register,
    AuthApiEndpoints.login,
    AuthApiEndpoints.refreshToken,
    AuthApiEndpoints.logout,
    AuthApiEndpoints.forgotPassword,
    AuthApiEndpoints.googleLogin,
    AuthApiEndpoints.googleCallback,
    DocumentEndpoints.public,
    AcademicEndpoints.public,
    '/assets',
  ];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = _isPublicPath(options.path, options.uri.path);

    if (!isPublic) {
      try {
        await _authService.refreshTokensIfNeeded();
      } catch (e) {
        if (kDebugMode) {
          print('Refresh token failed before request: $e');
        }
        await _tokenStorage.clearTokens();
        onSessionExpired?.call();
      }
    }

    final authHeader = await _tokenStorage.getAuthorizationHeader();
    if (authHeader != null) {
      options.headers['Authorization'] = authHeader;
    } else {
      options.headers.remove('Authorization');
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
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (kDebugMode) {
      print('ERROR[${err.response?.statusCode}] => MESSAGE: ${err.message}');
    }

    final statusCode = err.response?.statusCode;
    final alreadyRetried = err.requestOptions.extra[_retryKey] == true;
    final isPublic = _isPublicPath(
      err.requestOptions.path,
      err.requestOptions.uri.path,
    );

    if (statusCode == 401 && !alreadyRetried && !isPublic) {
      try {
        await _authService.refreshTokensIfNeeded(force: true);
        final authHeader = await _tokenStorage.getAuthorizationHeader();
        if (authHeader != null) {
          err.requestOptions.headers['Authorization'] = authHeader;
        }
        err.requestOptions.extra[_retryKey] = true;

        final response = await _retryDio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        if (kDebugMode) {
          print('401 refresh/retry failed: $e');
        }
        await _tokenStorage.clearTokens();
        onSessionExpired?.call();
      }
    }

    super.onError(err, handler);
  }

  bool _isPublicPath(String path, String uriPath) {
    return _publicPaths.any(
      (publicPath) =>
          path.contains(publicPath) || uriPath.contains(publicPath),
    );
  }
}
