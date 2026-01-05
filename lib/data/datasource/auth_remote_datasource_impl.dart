import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';
import '../../services/token_storage_service.dart';
import '../model/auth/request/login_request.dart';
import '../model/auth/request/register_request.dart';
import '../model/auth/response/api_response.dart';
import '../model/auth/response/token_data.dart';
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

      // Parse API response
      final apiResponse = ApiResponse<TokenData>.fromJson(
        response.data,
        (json) => TokenData.fromJson(json),
      );

      // Kiểm tra errorCode
      if (!apiResponse.isSuccess) {
        final errorCode = apiResponse.errorCode ?? 'UNKNOWN_ERROR';
        throw Exception('Login failed with error code: $errorCode');
      }

      // Kiểm tra data
      if (apiResponse.data == null) {
        throw Exception('Login response data is null');
      }

      final tokenData = apiResponse.data!;

      // Lưu tokens vào storage
      await tokenStorage.saveTokens(
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
        tokenType: tokenData.tokenType,
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

      final apiResponse = ApiResponse<void>.fromJson(response.data, null);

      if (!apiResponse.isSuccess) {
        final errorCode = apiResponse.errorCode ?? 'UNKNOWN_ERROR';
        throw Exception('Register failed with error code: $errorCode');
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

      // Parse API response
      final apiResponse = ApiResponse<TokenData>.fromJson(
        response.data,
        (json) => TokenData.fromJson(json),
      );

      // Kiểm tra errorCode
      if (!apiResponse.isSuccess) {
        final errorCode = apiResponse.errorCode ?? 'UNKNOWN_ERROR';
        throw Exception('Google login failed with error code: $errorCode');
      }

      // Kiểm tra data
      if (apiResponse.data == null) {
        throw Exception('Google login response data is null');
      }

      final tokenData = apiResponse.data!;

      // Lưu tokens vào storage
      await tokenStorage.saveTokens(
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
        tokenType: tokenData.tokenType,
      );

      // Trả về accessToken
      return tokenData.accessToken;
    } catch (e) {
      throw Exception('Google login failed: $e');
    }
  }
}

