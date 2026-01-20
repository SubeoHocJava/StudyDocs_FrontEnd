
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../model/auth/request/login_request.dart';
import '../../model/auth/request/register_request.dart';
import '../../model/api_response.dart'; // Deleted

import '../../model/auth/response/token_data.dart';
import '../../model/auth/response/user_me_response.dart';
import '../auth_remote_datasource.dart';

/// Implementation thật gọi API backend
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({
    required this.dioClient,
  });

  @override
  Future<TokenData> login({required LoginRequest request}) async {
    try {
      final response = await dioClient.post(
        AuthEndpoints.loginLocal,
        data: request.toJson(),
      );

      final ApiResponse<dynamic> apiResponse = response;

      if (!apiResponse.isSuccess) {
        throw Exception(apiResponse.errorCode ?? 'Login failed');
      }

      if (apiResponse.data == null) {
        throw Exception('Login response data is null');
      }

      return TokenData.fromJson(
        apiResponse.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> register({required RegisterRequest request}) async {
    try {
      final response = await dioClient.post(
        AuthEndpoints.register,
        data: request.toJson(),
      );

      final ApiResponse<dynamic> apiResponse = response;

      if (!apiResponse.isSuccess) {
        throw Exception(apiResponse.errorCode ?? 'Register failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TokenData> loginWithGoogle({String? idToken}) async {
    try {
      if (idToken == null || idToken.isEmpty) {
        throw Exception('idToken is required for Google login');
      }

      final response = await dioClient.post(
        AuthEndpoints.loginGoogle,
        data: {'tokenId': idToken},
      );

      final ApiResponse<dynamic> apiResponse = response;

      if (!apiResponse.isSuccess) {
        throw Exception(apiResponse.errorCode ?? 'Google login failed');
      }

      if (apiResponse.data == null) {
        throw Exception('Google login response data is null');
      }

      return TokenData.fromJson(
        apiResponse.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserMeResponse> getMe() async {
    try {
      // Sử dụng path từ ApiConstants nếu có, ở đây tôi dùng tạm string chuẩn
      final response = await dioClient.get('/auth/user/me');
      final ApiResponse<dynamic> apiResponse = response;

      if (!apiResponse.isSuccess) {
        throw Exception(apiResponse.errorCode ?? 'Failed to fetch user info');
      }

      final userData = apiResponse.data;
      if (userData == null) {
        throw Exception('User data is null');
      }

      return UserMeResponse.fromJson(userData as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
