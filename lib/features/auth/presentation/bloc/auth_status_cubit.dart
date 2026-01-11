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
  final String userId;
  final String username;
  final String displayName;
  final List<String> roles; // Danh sách roles

  AuthAuthenticated(
    this.accessToken, {
    this.role = 'user',
    this.userId = '',
    this.username = '',
    this.displayName = '',
    this.roles = const [],
  });

  @override
  List<Object?> get props => [
    accessToken,
    role,
    userId,
    username,
    displayName,
    roles,
  ];

  /// Check nếu user là admin
  bool get isAdmin => roles.contains('ROLE_ADMIN');
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
    final userId = await _tokenStorage.getUserId();
    final username = await _tokenStorage.getUsername();
    final displayName = await _tokenStorage.getDisplayName();
    final roles = await _tokenStorage.getRoles();

    if (token != null && token.isNotEmpty) {
      emit(
        AuthAuthenticated(
          token,
          role: role ?? 'user',
          userId: userId ?? '',
          username: username ?? '',
          displayName: displayName ?? '',
          roles: roles,
        ),
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Gọi sau khi login thành công
  /// Token + user info đã được lưu bởi datasource, chỉ cần update UI state
  void setAuthenticated({
    required String token,
    String role = 'user',
    String userId = '',
    String username = '',
    String displayName = '',
    List<String> roles = const [],
  }) {
    emit(
      AuthAuthenticated(
        token,
        role: role,
        userId: userId,
        username: username,
        displayName: displayName,
        roles: roles,
      ),
    );
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
