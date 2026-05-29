import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show VoidCallback, kDebugMode;
import 'package:studydocs/core/network/token_services.dart';
import 'package:studydocs/features/auth/data/keycloak_auth_service.dart';

import '../constants/api_constants.dart';

class ApiInterceptor extends QueuedInterceptor {
  static const _retryKey = 'auth_retry';

  final TokenStorageService _tokenStorage;
  final KeycloakAuthService _keycloakAuth;
  final VoidCallback? onSessionExpired;
  final Dio _retryDio;

  ApiInterceptor({
    TokenStorageService? tokenStorage,
    KeycloakAuthService? keycloakAuth,
    this.onSessionExpired,
    Dio? retryDio,
  })  : _tokenStorage = tokenStorage ?? TokenStorageService(),
        _keycloakAuth = keycloakAuth ?? KeycloakAuthService(),
        _retryDio = retryDio ?? Dio();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    const publicPaths = [
      AuthEndpoints.loginLocal,
      AuthEndpoints.loginGoogle,
      AuthEndpoints.register,
      AuthEndpoints.forgotPasswordRequest,
      AuthEndpoints.forgotPasswordConfirm,
      DocumentEndpoints.public,
      AcademicEndpoints.public,
      '/assets',
    ];

    final isPublic = publicPaths.any(
      (path) =>
          options.path.contains(path) || options.uri.path.contains(path),
    );

    if (!isPublic) {
      try {
        await _keycloakAuth.refreshTokensIfNeeded();
      } catch (e) {
        if (kDebugMode) {
          print('Refresh token failed before request: $e');
        }
        await _tokenStorage.clearTokens();
        onSessionExpired?.call();
      }

      final authHeader = await _tokenStorage.getAuthorizationHeader();
      if (authHeader != null) {
        options.headers['Authorization'] = authHeader;
      }
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
    final isPublic = _isPublicPath(err.requestOptions);

    if (statusCode == 401 && !alreadyRetried && !isPublic) {
      try {
        await _keycloakAuth.refreshTokensIfNeeded(force: true);
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

  bool _isPublicPath(RequestOptions options) {
    const publicPaths = [
      AuthEndpoints.loginLocal,
      AuthEndpoints.loginGoogle,
      AuthEndpoints.register,
      DocumentEndpoints.public,
      AcademicEndpoints.public,
    ];
    return publicPaths.any(
      (path) =>
          options.path.contains(path) || options.uri.path.contains(path),
    );
  }
}
