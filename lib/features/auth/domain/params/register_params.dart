// lib/features/auth/domain/params/register_params.dart
class RegisterParams {
  final String username;
  final String? email;
  final String password;
  final String? displayName;

  const RegisterParams({
    required this.username,
    this.email,
    required this.password,
    this.displayName,
  });
}