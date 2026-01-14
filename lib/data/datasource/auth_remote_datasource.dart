import 'package:studydocs/data/model/auth/request/login_request.dart' show LoginRequest;
import 'package:studydocs/data/model/auth/request/register_request.dart' show RegisterRequest;

import '../model/auth/response/token_data.dart';
import '../model/auth/response/user_me_response.dart';

/// Contract cho datasource auth
/// UI / Bloc / Repository KHÔNG biết implementation cụ thể
abstract class AuthRemoteDataSource {
  Future<TokenData> login({required LoginRequest request});
  Future<void> register({required RegisterRequest request});
  Future<TokenData> loginWithGoogle({String? idToken});
  Future<UserMeResponse> getMe();
}
