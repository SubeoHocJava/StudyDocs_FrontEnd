// lib/features/auth/domain/params/login_params.dart
class LoginParams {
  final String username;
  final String password;

  const LoginParams({
    required this.username,
    required this.password,
  });
}