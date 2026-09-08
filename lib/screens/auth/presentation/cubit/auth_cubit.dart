import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';
import 'package:studydocs/core/network/token_services.dart';

import 'package:studydocs/screens/auth/data/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_state.dart';
import 'package:studydocs/core/config/env_config.dart';

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
      if (kIsWeb) {
        await _loginWithGoogleWeb();
      } else {
        await _loginWithGoogleMobile();
      }
    } on AuthServiceException catch (e) {
      emit(AuthFailure(e.message));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      if (kDebugMode) {
        print('Google login error: $e');
      }
      emit(AuthFailure('Đăng nhập Google thất bại: $e'));
    }
  }

  Future<void> _loginWithGoogleWeb() async {
    // Không dùng signIn() thủ công trên Web nữa do bị Google chặn lấy idToken
    // UI sẽ hiển thị renderButton() và kết quả sẽ được xử lý qua handleWebGoogleAccount()
    emit(const AuthFailure('Vui lòng sử dụng nút đăng nhập của Google'));
  }

  Future<void> handleWebGoogleAccount(GoogleSignInAccount account) async {
    emit(const AuthLoading());
    try {
      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final idToken = googleAuth.idToken;
      
      if (idToken == null || idToken.isEmpty) {
        emit(const AuthFailure('Không lấy được xác thực từ Google'));
        return;
      }

      await _authService.completeGoogleLoginWithIdToken(idToken);
      await _emitAuthenticated();
    } on AuthServiceException catch (e) {
      emit(AuthFailure(e.message));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      if (kDebugMode) {
        print('Google login error: $e');
      }
      emit(AuthFailure('Đăng nhập Google thất bại: $e'));
    }
  }

  Future<void> _loginWithGoogleMobile() async {
    final googleSignIn = GoogleSignIn(
      clientId: EnvConfig.googleClientId,
      serverClientId: EnvConfig.googleWebClientId,
    );
    
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // User canceled the sign-in
      emit(const AuthFailure('Đã huỷ đăng nhập Google'));
      return;
    }
    
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    
    if (idToken == null || idToken.isEmpty) {
      emit(const AuthFailure('Không lấy được xác thực từ Google'));
      return;
    }

    await _authService.completeGoogleLoginWithIdToken(idToken);
    await _emitAuthenticated();
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
