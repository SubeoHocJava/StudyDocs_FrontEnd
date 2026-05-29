import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/network/token_services.dart';
import 'package:studydocs/features/auth/data/keycloak_auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final KeycloakAuthService _keycloakAuth;
  final TokenStorageService _tokenStorage;

  AuthCubit({
    KeycloakAuthService? keycloakAuth,
    TokenStorageService? tokenStorage,
  })  : _keycloakAuth = keycloakAuth ?? KeycloakAuthService(),
        _tokenStorage = tokenStorage ?? TokenStorageService(),
        super(const AuthInitial());

  Future<void> checkSession() async {
    final hasToken = await _tokenStorage.hasToken();
    if (!hasToken) {
      emit(const AuthUnauthenticated());
      return;
    }

    if (await _tokenStorage.isAccessTokenExpired()) {
      try {
        await _keycloakAuth.refreshTokensIfNeeded(force: true);
      } catch (_) {
        await _tokenStorage.clearTokens();
        emit(const AuthUnauthenticated());
        return;
      }
    }

    await _emitAuthenticated();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      await _keycloakAuth.loginWithPassword(
        username: username.trim(),
        password: password,
      );
      await _emitAuthenticated();
    } on KeycloakAuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(const AuthFailure('Đăng nhập thất bại. Vui lòng thử lại.'));
    }
  }

  Future<void> logout() async {
    await _keycloakAuth.logout();
    emit(const AuthUnauthenticated());
  }

  void sessionExpired() {
    if (state is! AuthUnauthenticated) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _emitAuthenticated() async {
    emit(
      AuthAuthenticated(
        displayName: await _tokenStorage.getDisplayName(),
        username: await _tokenStorage.getUsername(),
      ),
    );
  }
}
