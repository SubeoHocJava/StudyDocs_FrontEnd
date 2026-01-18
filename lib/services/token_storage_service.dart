import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service để lưu trữ và quản lý tokens (accessToken, refreshToken) + user info
/// Sử dụng SharedPreferences để lưu trữ tạm thời
///
/// TODO: Nếu cần bảo mật cao hơn, có thể dùng flutter_secure_storage
class TokenStorageService {
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyTokenType = 'token_type';
  static const String _keyRole = 'user_role';
  static const String _keyRoles = 'user_roles'; // Danh sách roles (JSON)
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';
  static const String _keyDisplayName = 'display_name';

  /// Kiểm tra xem Access Token sắp hết hạn chưa
  /// Trả về true nếu token null, invalid hoặc sắp hết hạn (còn < 1 phút)
  Future<bool> isAccessTokenExpired({int bufferSeconds = 60}) async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return true;

    try {
      final payload = _parseJwt(accessToken);
      if (payload['exp'] == null) return true;

      // 'exp' là timestamp (giây)
      final exp = payload['exp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch / 1000;

      // Nếu (exp - now) < buffer (ví dụ 60s) -> coi như hết hạn để refresh trước
      return (exp - now) < bufferSeconds;
    } catch (e) {
      // Decode lỗi -> coi như hết hạn
      return true;
    }
  }

  /// Helper giải mã JWT (không cần thư viện ngoài)
  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  /// Lưu tokens sau khi login thành công
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String tokenType = 'Bearer',
    String role = 'user',
    String? userId,
    String? username,
    String? displayName,
    List<String>? roles,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyTokenType, tokenType);
    await prefs.setString(_keyRole, role);

    if (userId != null) await prefs.setString(_keyUserId, userId);
    if (username != null) await prefs.setString(_keyUsername, username);
    if (displayName != null) {
      await prefs.setString(_keyDisplayName, displayName);
    }

    // Lưu roles dưới dạng JSON string
    if (roles != null && roles.isNotEmpty) {
      await prefs.setStringList(_keyRoles, roles);
    }
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

  /// Xóa tất cả tokens + user info (khi logout)
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyTokenType);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyDisplayName);
    await prefs.remove(_keyRoles);
  }

  /// Kiểm tra xem user đã login chưa
  Future<bool> hasToken() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  /// Lấy user ID
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  /// Lấy username
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  /// Lấy display name
  Future<String?> getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDisplayName);
  }

  /// Lấy danh sách roles
  Future<List<String>> getRoles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyRoles) ?? [];
  }

  /// Check nếu user có role admin
  Future<bool> isAdmin() async {
    final roles = await getRoles();
    return roles.contains('ROLE_ADMIN');
  }

  /// Lấy primary role (role đầu tiên)
  Future<String> getPrimaryRole() async {
    final roles = await getRoles();
    return roles.isNotEmpty ? roles.first : 'ROLE_USER';
  }
}
