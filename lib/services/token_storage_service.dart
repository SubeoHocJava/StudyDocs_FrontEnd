import 'package:shared_preferences/shared_preferences.dart';

/// Service để lưu trữ và quản lý tokens (accessToken, refreshToken)
/// Sử dụng SharedPreferences để lưu trữ tạm thời
/// 
/// TODO: Nếu cần bảo mật cao hơn, có thể dùng flutter_secure_storage
class TokenStorageService {
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyTokenType = 'token_type';
  static const String _keyRole = 'user_role';

  /// Lưu tokens sau khi login thành công
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String tokenType = 'Bearer',
    String role = 'user',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyTokenType, tokenType);
    await prefs.setString(_keyRole, role);
  }

  /// Lấy access token để dùng cho các request
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  /// Lấy refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  /// Lấy token type (thường là "Bearer")
  Future<String?> getTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTokenType);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  /// Lấy authorization header đầy đủ
  /// Ví dụ: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  Future<String?> getAuthorizationHeader() async {
    final accessToken = await getAccessToken();
    final tokenType = await getTokenType();
    
    if (accessToken == null) return null;
    return '${tokenType ?? 'Bearer'} $accessToken';
  }

  /// Xóa tất cả tokens (khi logout)
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyTokenType);
    await prefs.remove(_keyRole);
  }

  /// Kiểm tra xem user đã login chưa
  Future<bool> hasToken() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}

