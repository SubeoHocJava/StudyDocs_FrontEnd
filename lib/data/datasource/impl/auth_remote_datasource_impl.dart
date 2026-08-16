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
  Future<dynamic> startGoogleLogin(String codeChallenge, String codeChallengeMethod, String redirectUri) async {
    final response = await _client.post(AuthApiEndpoints.googleLogin, data: {
      'redirectUri': redirectUri,
      'codeChallenge': codeChallenge,
      'codeChallengeMethod': codeChallengeMethod,
    });
    if (response.isSuccess) return response.data;
    throw Exception('Failed to get Google login URL');
  }

  @override
  Future<dynamic> completeGoogleLogin(String code, String codeVerifier, String redirectUri) async {
    final response = await _client.post(AuthApiEndpoints.googleCallback, data: {
      'code': code,
      'codeVerifier': codeVerifier,
      'redirectUri': redirectUri,
    });
    if (response.isSuccess) return response.data;
    throw Exception('Failed to complete Google login');
  }
}
