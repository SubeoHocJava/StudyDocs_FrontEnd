/// Mock datasource giả lập API auth thật (cho dev/testing khi BE chưa deploy)
///
/// Logic giống như AuthRemoteDataSourceImpl:
/// 1. login() → trả về accessToken
/// 2. Auto gọi getMe() → lấy user info + roles
/// 3. Lưu vào storage (userId, username, displayName, roles)
///
/// Để switch sang mock, trong main.dart:
/// ```dart
/// // final dioClient = DioClient();
/// // final authDataSource = AuthRemoteDataSourceImpl(...);
/// final authDataSource = AuthMockDataSourceImpl();
/// ```
///
/// Test accounts (Mock):
/// - Username: user, Password: password123 → ROLE_USER
/// - Username: admin, Password: admin123 → ROLE_ADMIN

import 'package:studydocs/data/datasource/auth_remote_datasource.dart';
import 'package:studydocs/data/model/auth/request/login_request.dart';
import 'package:studydocs/data/model/auth/request/register_request.dart';
import 'package:studydocs/data/model/auth/response/user_me_response.dart';
import 'package:studydocs/services/token_storage_service.dart';

class AuthMockDataSourceImpl implements AuthRemoteDataSource {
  final TokenStorageService tokenStorage;

  // Mock users database - 2 tài khoản: admin + user
  // Key là username (dùng để login)
  static const Map<String, Map<String, dynamic>> _mockUsers = {
    'user': {
      'password': 'password123',
      'id': 'user-001',
      'email': 'user@example.com',
      'username': 'user',
      'displayName': 'User Account',
      'roles': ['ROLE_USER'],
      'isActive': true,
      'emailVerified': false,
    },
    'admin': {
      'password': 'admin123',
      'id': 'admin-001',
      'email': 'admin@example.com',
      'username': 'admin',
      'displayName': 'Admin User',
      'roles': ['ROLE_ADMIN', 'ROLE_USER'],
      'isActive': true,
      'emailVerified': true,
    },
  };

  AuthMockDataSourceImpl({TokenStorageService? tokenStorage})
    : tokenStorage = tokenStorage ?? TokenStorageService();

  @override
  Future<String> login({required LoginRequest request}) async {
    // Giả lập delay mạng
    await Future.delayed(const Duration(milliseconds: 1000));

    // Tìm user bằng username (LoginRequest dùng username, không phải email)
    final mockUser = _mockUsers[request.username];

    // Kiểm tra user + password
    if (mockUser == null || mockUser['password'] != request.password) {
      throw Exception('Login failed: Invalid username or password');
    }

    // Mock access token (giống format thật)
    const mockAccessToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyLTAwMSIsImVtYWlsIjoidXNlckBleGFtcGxlLmNvbSIsImlhdCI6MTcwNDk2NzM3Nn0.mock_token_string';
    const mockRefreshToken = 'refresh_token_mock_string';

    // Lưu token vào storage trước (giống impl)
    await tokenStorage.saveTokens(
      accessToken: mockAccessToken,
      refreshToken: mockRefreshToken,
      tokenType: 'Bearer',
    );

    // Gọi getMe() để lấy user info + roles (giống impl thực)
    final userMe = await getMe(mockUser);

    // Cập nhật storage với user info + roles (giống impl)
    await tokenStorage.saveTokens(
      accessToken: mockAccessToken,
      refreshToken: mockRefreshToken,
      tokenType: 'Bearer',
      userId: userMe.id,
      username: userMe.username,
      displayName: userMe.displayName,
      roles: userMe.roles,
    );

    return mockAccessToken;
  }

  @override
  Future<void> register({required RegisterRequest request}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Kiểm tra email đã tồn tại
    if (_mockUsers.containsKey(request.email)) {
      throw Exception('Register failed: Email already exists');
    }

    // Mock: không thực sự lưu vào DB
    throw Exception('Register not implemented in mock');
  }

  @override
  Future<String> loginWithGoogle({String? idToken}) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    if (idToken == null || idToken.isEmpty) {
      throw Exception('Google login failed: idToken is required');
    }

    // Mock: giả sử Google login luôn thành công với mock user
    const mockAccessToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.google_mock_token.signature';
    const mockRefreshToken = 'google_refresh_token_mock';

    await tokenStorage.saveTokens(
      accessToken: mockAccessToken,
      refreshToken: mockRefreshToken,
      tokenType: 'Bearer',
    );

    // Mock user từ Google
    final googleMockUser = {
      'id': 'google-user-001',
      'email': 'user@gmail.com',
      'username': 'google_user',
      'displayName': 'Google User',
      'roles': ['ROLE_USER'],
      'isActive': true,
      'emailVerified': true,
    };

    final userMe = await getMe(googleMockUser);

    await tokenStorage.saveTokens(
      accessToken: mockAccessToken,
      refreshToken: mockRefreshToken,
      tokenType: 'Bearer',
      userId: userMe.id,
      username: userMe.username,
      displayName: userMe.displayName,
      roles: userMe.roles,
    );

    return mockAccessToken;
  }

  /// Mock: Giả lập GET /api/user/me
  /// Lấy user info + roles từ _mockUsers hoặc mock data
  /// Giống như gọi API thực từ backend
  Future<UserMeResponse> getMe([Map<String, dynamic>? mockUserData]) async {
    // Giả lập delay mạng
    await Future.delayed(const Duration(milliseconds: 300));

    // Nếu không truyền data, lấy từ storage
    Map<String, dynamic>? userData = mockUserData;
    if (userData == null) {
      final userId = await tokenStorage.getUserId();
      if (userId == null || userId.isEmpty) {
        throw Exception('User not found');
      }

      // Tìm user trong mock database
      for (var entry in _mockUsers.entries) {
        if (entry.value['id'] == userId) {
          userData = entry.value;
          break;
        }
      }
    }

    if (userData == null) {
      throw Exception('User not found in mock database');
    }

    // Parse thành UserMeResponse (giống API thực)
    return UserMeResponse(
      id: userData['id'] ?? '',
      email: userData['email'] ?? '',
      username: userData['username'] ?? '',
      displayName: userData['displayName'] ?? '',
      isActive: userData['isActive'] ?? true,
      emailVerified: userData['emailVerified'] ?? false,
      createdAt: DateTime.now().toIso8601String(),
      roles: List<String>.from(userData['roles'] ?? []),
      permissions:
          (userData['roles'] as List<dynamic>?)?.contains('ROLE_ADMIN') == true
              ? ['READ_USER', 'WRITE_USER', 'DELETE_USER', 'READ_ADMIN']
              : ['READ_USER'],
      provider: 'local',
    );
  }
}
