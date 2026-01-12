import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';
import '../../services/token_storage_service.dart';
import '../model/auth/request/login_request.dart';
import '../model/auth/request/register_request.dart';
import '../model/api_response.dart'; // Deleted

import '../model/auth/response/token_data.dart';
import '../model/auth/response/user_me_response.dart';
import 'auth_remote_datasource.dart';

/// Implementation thật gọi API backend
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  final TokenStorageService tokenStorage;

  AuthRemoteDataSourceImpl({
    required this.dioClient,
    TokenStorageService? tokenStorage,
  }) : tokenStorage = tokenStorage ?? TokenStorageService();

  @override
  Future<String> login({required LoginRequest request}) async {
    try {
      // Call API login
      final response = await dioClient.post(
        ApiConstants.authLoginLocal,
        data: request.toJson(),
      );

      final ApiResponse<dynamic> apiResponse = response;

      // Kiểm tra errorCode
      if (!apiResponse.isSuccess) {
        final errorMsg =
            'Code: ${apiResponse.errorCode}, Status: ${apiResponse.statusCode}';
        throw Exception('Login failed: $errorMsg');
      }

      // Kiểm tra data
      if (apiResponse.data == null) {
        throw Exception('Login response data is null');
      }

      final tokenData = TokenData.fromJson(
        apiResponse.data as Map<String, dynamic>,
      );

      // Lưu tokens vào storage
      await tokenStorage.saveTokens(
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
        tokenType: tokenData.tokenType,
      );

      // Gọi getMe() để lấy thông tin user + roles
      final userMe = await getMe();

      // Cập nhật storage với user info + roles
      await tokenStorage.saveTokens(
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
        tokenType: tokenData.tokenType,
        userId: userMe.id,
        username: userMe.username,
        displayName: userMe.displayName,
        roles: userMe.roles,
      );

      // Trả về accessToken (để tương thích với interface cũ)
      return tokenData.accessToken;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> register({required RegisterRequest request}) async {
    try {
      // TODO: Implement khi có API register
      final response = await dioClient.post(
        ApiConstants.authRegister,
        data: request.toJson(),
      );

      final ApiResponse<dynamic> apiResponse = response;

      if (!apiResponse.isSuccess) {
        final errorMsg =
            'Code: ${apiResponse.errorCode}, Status: ${apiResponse.statusCode}';
        throw Exception('Register failed: $errorMsg');
      }
    } catch (e) {
      throw Exception('Register failed: $e');
    }
  }

  @override
  Future<String> loginWithGoogle({String? idToken}) async {
    try {
      if (idToken == null || idToken.isEmpty) {
        throw Exception('idToken is required for Google login');
      }

      // Call API Google login với idToken
      final response = await dioClient.post(
        ApiConstants.authLoginGoogle,
        data: {'tokenId': idToken},
      );

      final ApiResponse<dynamic> apiResponse = response;

      // Kiểm tra errorCode
      if (!apiResponse.isSuccess) {
        final errorMsg =
            'Code: ${apiResponse.errorCode}, Status: ${apiResponse.statusCode}';
        throw Exception('Google login failed: $errorMsg');
      }

      // Kiểm tra data
      if (apiResponse.data == null) {
        throw Exception('Google login response data is null');
      }

      final tokenData = TokenData.fromJson(
        apiResponse.data as Map<String, dynamic>,
      );

      // Lưu tokens vào storage
      await tokenStorage.saveTokens(
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
        tokenType: tokenData.tokenType,
      );

      // Gọi getMe() để lấy thông tin user + roles
      final userMe = await getMe();

      // Cập nhật storage với user info + roles
      await tokenStorage.saveTokens(
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
        tokenType: tokenData.tokenType,
        userId: userMe.id,
        username: userMe.username,
        displayName: userMe.displayName,
        roles: userMe.roles,
      );

      // Trả về accessToken
      return tokenData.accessToken;
    } catch (e) {
      throw Exception('Google login failed: $e');
    }
  }

  /// Gọi GET /api/user/me để lấy thông tin user + roles
  Future<UserMeResponse> getMe() async {
    try {
      final response = await dioClient.get('/auth/user/me');
      final ApiResponse<dynamic> apiResponse = response;

      if (!apiResponse.isSuccess) {
        final errorMsg =
            'Code: ${apiResponse.errorCode}, Status: ${apiResponse.statusCode}';
        throw Exception('Failed to fetch user info: $errorMsg');
      }

      // Parse data từ response
      final userData = apiResponse.data;
      if (userData == null) {
        throw Exception('User data is null');
      }

      final userMe = UserMeResponse.fromJson(userData as Map<String, dynamic>);
      return userMe;
    } catch (e) {
      throw Exception('Failed to get user info: $e');
    }
  }
}
