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
  final String role;

  AuthAuthenticated(this.accessToken, {this.role = 'user'});

  @override
  List<Object?> get props => [accessToken, role];
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
    final role = await _tokenStorage.getRole();
    if (token != null && token.isNotEmpty) {
      emit(AuthAuthenticated(token, role: role ?? 'user'));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Gọi sau khi login thành công
  /// Token đã được lưu bởi datasource, chỉ cần update UI state
  /// Gọi sau khi login thành công
  /// Lưu token và role vào storage, sau đó update UI state
  void setAuthenticated(String token, {String role = 'user'}) {
    _tokenStorage.saveTokens(
      accessToken: token,
      refreshToken: '',
      role: role,
    );
    emit(AuthAuthenticated(token, role: role));
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

