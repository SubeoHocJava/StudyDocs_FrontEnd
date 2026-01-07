import '../repository/profile_repository.dart';

class VerifyEmailUseCase {
  final ProfileRepository repository;
  VerifyEmailUseCase(this.repository);

  Future<void> call() {
    return repository.verifyEmail();
  }
}
