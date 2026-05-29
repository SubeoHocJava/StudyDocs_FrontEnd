import 'package:dio/dio.dart';
import 'package:studydocs/core/config/env_config.dart';
import 'package:studydocs/core/network/token_services.dart';
import 'package:studydocs/core/utils/jwt_utils.dart';

class KeycloakAuthException implements Exception {
  final String message;
  KeycloakAuthException(this.message);

  @override
  String toString() => message;
}

class KeycloakAuthService {
  final Dio _dio;
  final TokenStorageService _tokenStorage;
  Future<void>? _refreshInFlight;

  KeycloakAuthService({
    Dio? dio,
    TokenStorageService? tokenStorage,
  })  : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/x-www-form-urlencoded',
                  'Accept': 'application/json',
                },
              ),
            ),
        _tokenStorage = tokenStorage ?? TokenStorageService();

  Map<String, String> get _clientFields {
    final fields = <String, String>{
      'client_id': EnvConfig.keycloakClientId,
    };
    final secret = EnvConfig.keycloakClientSecret;
    if (secret.isNotEmpty) {
      fields['client_secret'] = secret;
    }
    return fields;
  }

  Future<void> loginWithPassword({
    required String username,
    required String password,
  }) async {
    _ensureConfigured();
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        EnvConfig.tokenEndpoint,
        data: {
          ..._clientFields,
          'grant_type': 'password',
          'username': username,
          'password': password,
          'scope': 'openid',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.json,
        ),
      );
      await _handleTokenResponse(response.data);
    } on DioException catch (e) {
      throw KeycloakAuthException(_messageFromDio(e));
    }
  }

  /// Refresh khi access sắp hết hạn (&lt; 60s) hoặc [force] sau 401.
  Future<void> refreshTokensIfNeeded({bool force = false}) async {
    _ensureConfigured();

    if (!force && !await _tokenStorage.isAccessTokenExpired()) {
      return;
    }

    if (_refreshInFlight != null) {
      return _refreshInFlight!;
    }

    _refreshInFlight = _refreshTokens().whenComplete(() {
      _refreshInFlight = null;
    });
    return _refreshInFlight!;
  }

  Future<void> _refreshTokens() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw KeycloakAuthException('Không có refresh token');
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        EnvConfig.tokenEndpoint,
        data: {
          ..._clientFields,
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.json,
        ),
      );
      await _handleTokenResponse(response.data);
    } on DioException catch (e) {
      throw KeycloakAuthException(_messageFromDio(e));
    }
  }

  /// Gọi Keycloak logout (best-effort) rồi xóa token local.
  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (EnvConfig.isKeycloakConfigured &&
        refreshToken != null &&
        refreshToken.isNotEmpty) {
      try {
        await _dio.post<void>(
          EnvConfig.logoutEndpoint,
          data: {
            ..._clientFields,
            'refresh_token': refreshToken,
          },
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ),
        );
      } on DioException {
        // Vẫn xóa local dù Keycloak logout lỗi mạng
      }
    }

    await _tokenStorage.clearTokens();
  }

  Future<void> _handleTokenResponse(Map<String, dynamic>? data) async {
    if (data == null || data['access_token'] == null) {
      throw KeycloakAuthException('Phản hồi token không hợp lệ');
    }
    await _persistTokenResponse(data);
  }

  Future<void> _persistTokenResponse(Map<String, dynamic> data) async {
    final accessToken = data['access_token'] as String;
    final refreshToken = data['refresh_token'] as String? ?? '';
    final tokenType = data['token_type'] as String? ?? 'Bearer';
    final idToken = data['id_token'] as String?;

    final claims = JwtUtils.decodePayload(accessToken);
    final roles = JwtUtils.extractRealmRoles(accessToken);

    await _tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      idToken: idToken,
      userId: claims['sub']?.toString(),
      username: claims['preferred_username']?.toString(),
      displayName: claims['name']?.toString(),
      roles: roles,
      role: roles.isNotEmpty ? roles.first : 'user',
    );
  }

  void _ensureConfigured() {
    if (!EnvConfig.isKeycloakConfigured) {
      throw KeycloakAuthException(
        'Thiếu cấu hình Keycloak trong file .env',
      );
    }
  }

  String _messageFromDio(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final description = data['error_description'] ?? data['message'];
      if (description != null) return description.toString();
      final error = data['error'];
      if (error != null) return error.toString();
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Không kết nối được Keycloak. Kiểm tra KEYCLOAK_BASE_URL và mạng.';
    }
    return 'Xác thực thất bại (${e.response?.statusCode ?? 'lỗi mạng'})';
  }
}
