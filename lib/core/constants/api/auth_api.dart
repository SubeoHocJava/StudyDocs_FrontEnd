/// User Service — public auth endpoints (không cần Bearer).
/// Tất cả POST body: **application/json** (khớp Postman collection).
class AuthApiEndpoints {
  AuthApiEndpoints._();

  static const String publicBase = 'auth/public/auth';

  static const String register = '$publicBase/register';
  static const String login = '$publicBase/login';
  static const String refreshToken = '$publicBase/refresh-token';
  static const String logout = '$publicBase/logout';
  static const String forgotPassword = '$publicBase/forgot-password';
  static const String googleLogin = '$publicBase/google/login';
  static const String googleCallback = '$publicBase/google/callback';
}
