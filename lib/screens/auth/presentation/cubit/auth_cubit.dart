import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';
import 'package:studydocs/core/network/token_services.dart';
import 'package:studydocs/core/utils/pkce_utils.dart';
import 'package:studydocs/screens/auth/data/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  final TokenStorageService _tokenStorage;

  AuthCubit({
    AuthService? authService,
    TokenStorageService? tokenStorage,
  })  : _authService = authService ?? AuthService(),
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
        await _authService.refreshTokensIfNeeded(force: true);
      } catch (_) {
        await _tokenStorage.clearTokens();
        emit(const AuthUnauthenticated());
        return;
      }
    }

    try {
      await _authService.syncCurrentUser();
    } catch (_) {
      // Token còn hạn nhưng /me lỗi — vẫn hiển thị đã login với data cache
    }

    await _emitAuthenticated();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      await _authService.login(username: username, password: password);
      await _emitAuthenticated();
    } on AuthServiceException catch (e) {
      emit(AuthFailure(e.message));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(const AuthFailure('Đăng nhập thất bại. Vui lòng thử lại.'));
    }
  }

  Future<void> register({
    required String username,
    required String password,
    String? fullName,
  }) async {
    emit(const AuthLoading());
    try {
      await _authService.register(
        username: username,
        password: password,
        fullName: fullName,
      );
      emit(const AuthRegisterSuccess());
    } on AuthServiceException catch (e) {
      emit(AuthFailure(e.message));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(const AuthFailure('Đăng ký thất bại. Vui lòng thử lại.'));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(const AuthLoading());
    try {
      final pkce = PkceUtils.generate();
      _authService.pendingGoogleCodeVerifier = pkce.codeVerifier;

      final url = await _authService.startGoogleLogin(
        codeChallenge: pkce.codeChallenge,
      );

      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw AuthServiceException(
          'Không mở được trình duyệt đăng nhập Google',
        );
      }

      emit(const AuthGooglePending());
    } on AuthServiceException catch (e) {
      emit(AuthFailure(e.message));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(const AuthFailure('Không thể bắt đầu đăng nhập Google'));
    }
  }

  /// Gọi từ deep link handler: `studydocs://callback?code=...`
  Future<void> handleGoogleCallback(String code) async {
    final verifier = _authService.pendingGoogleCodeVerifier;
    if (verifier == null || verifier.isEmpty) {
      emit(const AuthFailure('Phiên Google hết hạn, thử lại.'));
      return;
    }

    emit(const AuthLoading());
    try {
      await _authService.completeGoogleLogin(
        code: code,
        codeVerifier: verifier,
      );
      await _emitAuthenticated();
    } on AuthServiceException catch (e) {
      emit(AuthFailure(e.message));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(const AuthFailure('Đăng nhập Google thất bại'));
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    emit(const AuthUnauthenticated());
  }

  void sessionExpired() {
    if (state is! AuthUnauthenticated) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> updateUserAvatar(String newUrl) async {
    await _tokenStorage.saveAvatarUrl(newUrl);
    if (state is AuthAuthenticated) {
      final current = state as AuthAuthenticated;
      emit(AuthAuthenticated(
        userId: current.userId,
        displayName: current.displayName,
        username: current.username,
        avatarUrl: newUrl,
      ));
    }
  }

  Future<void> _emitAuthenticated() async {
    emit(
      AuthAuthenticated(
        userId: await _tokenStorage.getUserId(),
        displayName: await _tokenStorage.getDisplayName(),
        username: await _tokenStorage.getUsername(),
        avatarUrl: await _tokenStorage.getAvatarUrl(),
      ),
    );
  }
}
