import 'package:studydocs/data/datasource/auth_remote_datasource.dart';
import 'package:studydocs/features/auth/domain/repositories/auth_repository.dart';
import 'package:studydocs/services/token_storage_service.dart';
import 'package:studydocs/data/model/auth/request/login_request.dart';
import 'package:studydocs/data/model/auth/request/register_request.dart';
import 'package:studydocs/data/model/auth/response/user_me_response.dart';
import 'package:studydocs/features/auth/domain/params/login_params.dart';
import 'package:studydocs/features/auth/domain/params/register_params.dart';

/// Implement cụ thể của [AuthRepository] sử dụng [AuthRemoteDataSource].
/// Tầng này có nhiệm vụ:
/// - Điều phối luồng dữ liệu (Orchestration)
/// - Quản lý trạng thái lưu trữ (Persistence)
/// - Đảm bảo tính toàn vẹn (Cleanup on failure)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenStorageService storage;

  AuthRepositoryImpl({
    required this.remote,
    TokenStorageService? storage,
  }) : storage = storage ?? TokenStorageService();

  @override
  Future<UserMeResponse> login({
    required LoginParams params,
  }) async {
    try {
      // 1. Gọi API Login lấy Token
      final tokenData = await remote.login(
        request: LoginRequest(
          username: params.username,
          password: params.password,
        ),
      );

      // 2. Lưu token tạm thời (Cần thiết để gọi getMe ngay sau đó)
      await storage.saveTokens(
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
        tokenType: tokenData.tokenType,
      );

      // 3. Gọi API lấy thông tin chi tiết User
      final userMe = await remote.getMe();

      // 4. Lưu đầy đủ thông tin vào storage
      await storage.saveTokens(
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
        tokenType: tokenData.tokenType,
        userId: userMe.id,
        username: userMe.username,
        displayName: userMe.displayName,
        roles: userMe.roles,
      );

      return userMe;
    } catch (e) {
      // 5. CLEANUP: Nếu bất kỳ bước nào lỗi, xóa hết token để tránh lỗi "nửa đăng nhập"
      await storage.clearTokens();
      rethrow;
    }
  }

  @override
  Future<UserMeResponse> loginWithGoogle({String? idToken}) async {
    try {
      // 1. Gọi API Login Google
      final tokenData = await remote.loginWithGoogle(idToken: idToken);

      // 2. Lưu token tạm thời
      await storage.saveTokens(
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
        tokenType: tokenData.tokenType,
      );

      // 3. Lấy profile user
      final userMe = await remote.getMe();

      // 4. Update storage
      await storage.saveTokens(
        accessToken: tokenData.accessToken,
        refreshToken: tokenData.refreshToken,
        tokenType: tokenData.tokenType,
        userId: userMe.id,
        username: userMe.username,
        displayName: userMe.displayName,
        roles: userMe.roles,
      );

      return userMe;
    } catch (e) {
      await storage.clearTokens();
      rethrow;
    }
  }

  @override
  Future<void> register({
    required RegisterParams params,
  }) {
    return remote.register(
      request: RegisterRequest(
        username: params.username,
        email: params.email,
        password: params.password,
        displayName: params.displayName,
      ),
    );
  }
}

