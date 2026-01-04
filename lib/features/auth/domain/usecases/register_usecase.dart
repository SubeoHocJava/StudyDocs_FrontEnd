import '../params/register_params.dart';
import '../repositories/auth_repository.dart';
/// UseCase cho phép UI/BLoC gọi hành động đăng ký mà không cần biết tầng dưới.
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<void> call({
    required RegisterParams params,
  }) {
    return repository.register(
      params: params,
    );
  }
}

