import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studydocs/data/model/auth/request/login_request.dart' show LoginRequest;
import 'package:studydocs/data/model/auth/request/register_request.dart' show RegisterRequest;

import '../../../core/network/dio_client.dart';
import '../auth_remote_datasource.dart';
import 'auth_remote_datasource_impl.dart';
import '../../model/auth/response/token_data.dart';
import '../../model/auth/response/user_me_response.dart';

/// Datasource "hybrid":
/// - Login/Register: dùng API THẬT
/// - Google login: dùng GoogleSignIn thật để lấy `idToken` (JWT)
class AuthRemoteDataSourceHybrid implements AuthRemoteDataSource {
  final AuthRemoteDataSource _implementation;
  final GoogleSignIn _googleSignIn;

  /// OAuth Client IDs (không phải secret).
  ///
  /// - Web client id: dùng làm `serverClientId` để request `idToken` (JWT) ổn định.
  static const String _webClientId =
      '336989269103-d060nsigegat7ndskdeh28krr120qaql.apps.googleusercontent.com';

  AuthRemoteDataSourceHybrid({
    AuthRemoteDataSource? implementation,
    GoogleSignIn? googleSignIn,
  })  : _implementation = implementation ?? AuthRemoteDataSourceImpl(dioClient: DioClient()),
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: const ['email', 'profile'],
              serverClientId: _webClientId,
            );

  @override
  Future<TokenData> login({required LoginRequest request}) {
    return _implementation.login(request: request);
  }

  @override
  Future<void> register({required RegisterRequest request}) {
    return _implementation.register(request: request);
  }

  @override
  Future<TokenData> loginWithGoogle({String? idToken}) async {
    // Nếu chưa có idToken, lấy từ Google Sign In
    String? googleIdToken = idToken;
    
    if (googleIdToken == null) {
      // Logout session cũ để bắt user chọn tài khoản mỗi lần
      await _googleSignIn.signOut();
      
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw Exception('Đăng nhập Google đã bị huỷ');
      }

      final auth = await account.authentication;
      googleIdToken = auth.idToken;
      if (googleIdToken == null || googleIdToken.isEmpty) {
        throw Exception('Không lấy được idToken từ Google');
      }
      
      // CHỈ DEV: log toàn bộ idToken để copy test với BE
      debugPrint('==== GOOGLE ID TOKEN (DEV) ====');
      debugPrint(googleIdToken);
      debugPrint('==== END GOOGLE ID TOKEN ====');
    }
    
    // Gửi idToken lên backend để verify và lấy accessToken/refreshToken
    return _implementation.loginWithGoogle(idToken: googleIdToken);
  }

  @override
  Future<UserMeResponse> getMe() {
    return _implementation.getMe();
  }
}
