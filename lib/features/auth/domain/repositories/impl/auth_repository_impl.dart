import 'package:studydocs/data/datasource/auth_remote_datasource.dart';
import 'package:studydocs/features/auth/domain/repositories/auth_repository.dart';

import '../../../../../data/model/auth/request/login_request.dart';
import '../../../../../data/model/auth/request/register_request.dart';
import '../../params/login_params.dart';
import '../../params/register_params.dart';

/// Implement cụ thể của [AuthRepository] sử dụng [AuthRemoteDataSource].
/// Tầng này có nhiệm vụ:
/// - Gọi datasource
/// - Xử lý map dữ liệu nếu cần
/// - Bọc và chuẩn hoá lỗi (nếu muốn)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl({required this.remote});

  @override
  Future<String> login({
    required LoginParams params,
  }) {
    return remote.login(
      request: LoginRequest(
        username: params.username,
        password: params.password,
      ),
    );
  }

  @override
  Future<String> loginWithGoogle(){
    return remote.loginWithGoogle();
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
      ),
    );
  }
}

