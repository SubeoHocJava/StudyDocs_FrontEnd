import '../model/auth/request/login_request.dart';
import '../model/auth/request/register_request.dart';

/// Contract cho datasource auth
/// UI / Bloc / Repository KHÔNG biết implementation cụ thể
abstract class AuthRemoteDataSource {
  Future<String> login({required LoginRequest request});
  Future<void> register({required RegisterRequest request});
  Future<String> loginWithGoogle({String? idToken});
}
