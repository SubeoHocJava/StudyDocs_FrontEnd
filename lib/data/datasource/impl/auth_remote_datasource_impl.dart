import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/constants/api/auth_api.dart';
import '../auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSourceImpl({DioClient? client}) : _client = client ?? DioClient();

  @override
  Future<dynamic> login(String username, String password) async {
    final response = await _client.post(AuthApiEndpoints.login, data: {
      'username': username,
      'password': password,
    });
    if (response.isSuccess) return response.data;
    throw Exception('Login failed');
  }

  @override
  Future<dynamic> register(Map<String, dynamic> data) async {
    final response = await _client.post(AuthApiEndpoints.register, data: data);
    if (response.isSuccess) return response.data;
    throw Exception('Registration failed');
  }

  @override
  Future<dynamic> verifyOtp(String email, String otp) async {
    final response = await _client.post('/user/public/auth/verify-otp', data: {
      'email': email,
      'otp': otp,
    });
    if (response.isSuccess) return response.data;
    throw Exception('OTP verification failed');
  }

  @override
  Future<dynamic> refreshToken(String token) async {
    final response = await _client.post(AuthApiEndpoints.refreshToken, data: {
      'refreshToken': token,
    });
    if (response.isSuccess) return response.data;
    throw Exception('Token refresh failed');
  }

  @override
  Future<dynamic> logout() async {
    final response = await _client.post(AuthApiEndpoints.logout);
    if (response.isSuccess) return response.data;
    throw Exception('Logout failed');
  }

  @override
  Future<dynamic> completeGoogleLoginWithIdToken(String idToken) async {
    final response = await _client.post(AuthApiEndpoints.googleCallback, data: {
      'idToken': idToken,
    });
    if (response.isSuccess) return response.data;
    throw Exception('Failed to complete Google login');
  }

  @override
  Future<dynamic> forgotPassword(String email) async {
    final response = await _client.post(AuthApiEndpoints.forgotPassword, data: {
      'email': email,
    });
    if (response.isSuccess) return response.data;
    throw Exception('Forgot password failed');
  }

  @override
  Future<dynamic> verifyResetToken(String email, String token) async {
    final response = await _client.post(AuthApiEndpoints.verifyResetToken, data: {
      'email': email,
      'token': token,
    });
    if (response.isSuccess) return response.data;
    throw Exception('Verify reset token failed');
  }

  @override
  Future<dynamic> resetPassword(String email, String token, String newPassword) async {
    final response = await _client.post(AuthApiEndpoints.resetPassword, data: {
      'email': email,
      'token': token,
      'newPassword': newPassword,
    });
    if (response.isSuccess) return response.data;
    throw Exception('Reset password failed');
  }
}
