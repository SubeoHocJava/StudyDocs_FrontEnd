import 'dart:async';

import '../model/auth/request/login_request.dart';
import '../model/auth/request/register_request.dart';
import 'auth_remote_datasource.dart';

/// Mock DataSource phục vụ giai đoạn phát triển giao diện.
/// Sau này chỉ cần thay bằng API implementation.
class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  final List<Map<String, String>> _mockUsers = [
    {
      'username': 'hao',
      'name': 'Nguyễn Văn Hảo',
      'email': 'hao@gmail.com',
      'password': '123456',
      'token': 'token_hao_123456',
      'role': 'user',
    },
    {
      'username': 'admin',
      'name': 'Admin',
      'email': 'admin@example.com',
      'password': 'admin123',
      'token': 'token_admin_123',
      'role': 'admin',
    },
  ];

  @override
  Future<String> login({
    required LoginRequest request,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final user = _mockUsers.firstWhere(
          (u) => u['username'] == request.username && u['password'] == request.password,
      orElse: () => {},
    );

    if (user.isEmpty) {
      throw Exception('Tên đăng nhập hoặc mật khẩu không đúng');
    }

    return '${user['token']!}|${user['role']!}';
  }

  @override
  Future<void> register({
    required RegisterRequest request,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final existedUsername = _mockUsers.any(
          (u) => u['username'] == request.username,
    );
    if (existedUsername) {
      throw Exception('Tên đăng nhập đã tồn tại');
    }

    final existedEmail = _mockUsers.any(
          (u) => u['email'] == request.email,
    );
    if (existedEmail) {
      throw Exception('Email đã tồn tại');
    }

    _mockUsers.add({
      'username': request.username,
      'name': request.username,
      'email': request.email ?? '',
      'password': request.password,
      'token': 'token_${request.username.hashCode}',
    });
  }

  @override
  Future<String> loginWithGoogle({String? idToken}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return 'mock_google_token_${DateTime.now().millisecondsSinceEpoch}';
  }
}
