import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_remote_datasource.dart';
import 'auth_remote_datasource_mock.dart';
import '../model/auth/request/login_request.dart';
import '../model/auth/request/register_request.dart';

/// Datasource "hybrid":
/// - Login/Register: dùng mock để bạn dev UI nhanh
/// - Google login: dùng GoogleSignIn thật để lấy `idToken` (JWT) phục vụ demo
///
/// Sau này khi có API:
/// - bạn thay mock bằng implementation gọi Dio
/// - vẫn có thể giữ `idToken` để gửi về backend verify
class AuthRemoteDataSourceHybrid implements AuthRemoteDataSource {
  final AuthRemoteDataSource _fallback;
  final GoogleSignIn _googleSignIn;

  /// OAuth Client IDs (không phải secret).
  ///
  /// - Android client id: dùng để cấu hình OAuth trên Google Cloud (package + SHA-1).
  ///   Thường không cần nhét vào code.
  /// - Web client id: dùng làm `serverClientId` để request `idToken` (JWT) ổn định.
  // ignore: unused_field
  static const String _androidClientId =
      '336989269103-hh1k1nqbk85sqthpojni89c286s7ff49.apps.googleusercontent.com';
  static const String _webClientId =
      '336989269103-d060nsigegat7ndskdeh28krr120qaql.apps.googleusercontent.com';

  AuthRemoteDataSourceHybrid({
    AuthRemoteDataSource? fallback,
    GoogleSignIn? googleSignIn,
  })  : _fallback = fallback ?? AuthRemoteDataSourceMock(),
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: const ['email', 'profile'],
              serverClientId: _webClientId,
            );

  @override
  Future<String> login({required LoginRequest request}) {
    return _fallback.login(request: request);
  }

  @override
  Future<void> register({required RegisterRequest request}) {
    return _fallback.register(request: request);
  }

  @override
  Future<String> loginWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Đăng nhập Google đã bị huỷ');
    }

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Không lấy được idToken từ Google');
    }
    // CHỈ DEV: log toàn bộ idToken để copy test với BE
    debugPrint('==== GOOGLE ID TOKEN (DEV) ====');
    debugPrint(idToken);
    debugPrint('==== END GOOGLE ID TOKEN ====');
    // Trả về JWT (idToken). UI có thể decode để show email/name chứng minh login OK.
    return idToken;
  }
}

