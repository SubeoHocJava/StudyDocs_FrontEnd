// lib/features/auth/domain/usecases/google_login_usecase.dart
import '../repositories/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository repository;

  GoogleLoginUseCase({required this.repository});

  Future<String> call() {

    return repository.loginWithGoogle();
  }
}
