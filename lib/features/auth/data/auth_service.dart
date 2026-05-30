import 'package:studydocs/core/constants/api/auth_api.dart';
import 'package:studydocs/core/constants/api/user_api.dart';
import 'package:studydocs/core/config/env_config.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/network/token_services.dart';
import 'package:studydocs/core/utils/jwt_utils.dart';
import 'package:studydocs/data/model/global/api_response.dart';
import 'package:studydocs/data/model/user/User.dart';
import 'package:studydocs/features/auth/data/models/auth_token_dto.dart';

class AuthServiceException implements Exception {
  final String message;
  AuthServiceException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final DioClient _dioClient;
  final TokenStorageService _tokenStorage;
  Future<void>? _refreshInFlight;

  /// Lưu PKCE verifier giữa bước mở URL Google và callback.
  String? pendingGoogleCodeVerifier;

  AuthService({
    DioClient? dioClient,
    TokenStorageService? tokenStorage,
  })  : _dioClient = dioClient ?? DioClient(),
        _tokenStorage = tokenStorage ?? TokenStorageService();

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final response = await _dioClient.post(
      AuthApiEndpoints.login,
      data: {
        'username': username.trim(),
        'password': password,
      },
    );
    await _handleAuthResponse(response);
    await syncCurrentUser();
  }

  Future<void> register({
    required String username,
    required String password,
    String? fullName,
  }) async {
    final body = <String, dynamic>{
      'username': username.trim(),
      'password': password,
    };
    if (fullName != null && fullName.trim().isNotEmpty) {
      body['fullName'] = fullName.trim();
    }

    final response = await _dioClient.post(
      AuthApiEndpoints.register,
      data: body,
    );
    if (!response.isSuccess) {
      if (response.statusCode == 409) {
        throw AuthServiceException(
          'Tài khoản đã tồn tại. Vui lòng dùng tên đăng nhập khác hoặc đăng nhập.',
        );
      }
      throw AuthServiceException('Đăng ký thất bại');
    }
  }

  Future<void> refreshTokensIfNeeded({bool force = false}) async {
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
      throw AuthServiceException('Không có refresh token');
    }

    final response = await _dioClient.post(
      AuthApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );
    await _handleAuthResponse(response);
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await _dioClient.post(
          AuthApiEndpoints.logout,
          data: {'refreshToken': refreshToken},
        );
      } catch (_) {
        // Best-effort — vẫn xóa local
      }
    }
    await _tokenStorage.clearTokens();
  }

  /// Bước 1 Google OAuth: lấy URL đăng nhập từ BE.
  Future<String> startGoogleLogin({
    required String codeChallenge,
    String codeChallengeMethod = 'S256',
  }) async {
    final response = await _dioClient.post(
      AuthApiEndpoints.googleLogin,
      data: {
        'redirectUri': EnvConfig.googleRedirectUri,
        'codeChallenge': codeChallenge,
        'codeChallengeMethod': codeChallengeMethod,
      },
    );
    if (!response.isSuccess || response.data == null) {
      throw AuthServiceException('Không lấy được URL đăng nhập Google');
    }
    final dto = GoogleAuthUrlDto.fromJson(
      response.data as Map<String, dynamic>,
    );
    if (dto.authorizationUrl.isEmpty) {
      throw AuthServiceException('URL đăng nhập Google không hợp lệ');
    }
    return dto.authorizationUrl;
  }

  /// Bước 2 Google OAuth: đổi code lấy token.
  Future<void> completeGoogleLogin({
    required String code,
    required String codeVerifier,
  }) async {
    final response = await _dioClient.post(
      AuthApiEndpoints.googleCallback,
      data: {
        'code': code,
        'codeVerifier': codeVerifier,
        'redirectUri': EnvConfig.googleRedirectUri,
      },
    );
    await _handleAuthResponse(response);
    await syncCurrentUser();
    pendingGoogleCodeVerifier = null;
  }

  /// GET /users/me — lưu userId, tên hiển thị sau login/refresh session.
  Future<User> syncCurrentUser() async {
    final response = await _dioClient.get(UserEndpoints.me);
    if (!response.isSuccess || response.data == null) {
      throw AuthServiceException('Không lấy được thông tin người dùng');
    }
    final user = User.fromJson(response.data as Map<String, dynamic>);

    final accessToken = await _tokenStorage.getAccessToken();
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (accessToken == null || accessToken.isEmpty) {
      throw AuthServiceException('Chưa có access token');
    }

    List<String> roles = [];
    try {
      roles = JwtUtils.extractRealmRoles(accessToken);
    } catch (_) {}

    await _tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken ?? '',
      tokenType: (await _tokenStorage.getTokenType()) ?? 'Bearer',
      userId: user.id,
      username: user.username,
      displayName: user.fullName,
      roles: roles.isNotEmpty ? roles : null,
      role: roles.isNotEmpty ? roles.first : 'user',
    );
    return user;
  }

  Future<void> _handleAuthResponse(ApiResponse<dynamic> response) async {
    if (!response.isSuccess) {
      throw AuthServiceException('Xác thực thất bại');
    }
    if (response.data == null) {
      throw AuthServiceException('Phản hồi token không hợp lệ');
    }
    final token = AuthTokenDto.fromJson(
      response.data as Map<String, dynamic>,
    );
    await _persistToken(token);
  }

  Future<void> _persistToken(AuthTokenDto token) async {
    List<String> roles = [];
    String? username;
    String? displayName;
    String? userId;

    try {
      final claims = JwtUtils.decodePayload(token.accessToken);
      roles = JwtUtils.extractRealmRoles(token.accessToken);
      username = claims['preferred_username']?.toString();
      displayName = claims['name']?.toString();
      userId = claims['sub']?.toString();
    } catch (_) {}

    await _tokenStorage.saveTokens(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
      tokenType: token.tokenType,
      userId: userId,
      username: username,
      displayName: displayName,
      roles: roles.isNotEmpty ? roles : null,
      role: roles.isNotEmpty ? roles.first : 'user',
    );
  }
}
