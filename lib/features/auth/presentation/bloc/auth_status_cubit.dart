import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../services/token_storage_service.dart';

/// State cho auth status toàn app
abstract class AuthStatus extends Equatable {
  @override
  List<Object?> get props => [];
}

/// User chưa đăng nhập
class AuthUnauthenticated extends AuthStatus {}

/// User đã đăng nhập
class AuthAuthenticated extends AuthStatus {
  final String accessToken;

  AuthAuthenticated(this.accessToken);

  @override
  List<Object?> get props => [accessToken];
}

/// Cubit quản lý trạng thái đăng nhập toàn app
/// - Kiểm tra auth status khi app start (persistent login)
/// - Update status sau khi login/logout
/// - Header và các component khác có thể lắng nghe để update UI
class AuthStatusCubit extends Cubit<AuthStatus> {
  final TokenStorageService _tokenStorage;

  AuthStatusCubit({TokenStorageService? tokenStorage})
      : _tokenStorage = tokenStorage ?? TokenStorageService(),
        super(AuthUnauthenticated());

  /// Kiểm tra trạng thái login khi app start
  /// Nếu có token đã lưu → emit AuthAuthenticated
  Future<void> checkAuthStatus() async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      emit(AuthAuthenticated(token));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Gọi sau khi login thành công
  /// Token đã được lưu bởi datasource, chỉ cần update UI state
  void setAuthenticated(String token) {
    emit(AuthAuthenticated(token));
  }

  /// Gọi khi user logout
  /// Xóa tokens và emit AuthUnauthenticated
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
    emit(AuthUnauthenticated());
  }

  /// Kiểm tra xem user đã login chưa
  bool get isAuthenticated => state is AuthAuthenticated;
}

