import '../repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase({required this.repository});
}

class GoogleLoginUseCase {
  final AuthRepository repository;
  GoogleLoginUseCase({required this.repository});
}

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase({required this.repository});
}
