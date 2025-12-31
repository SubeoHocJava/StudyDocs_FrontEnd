import '../params/login_params.dart';
import '../repositories/auth_repository.dart';

/// UseCase thể hiện 1 "hành động nghiệp vụ" cụ thể: đăng nhập.
/// BLoC sẽ chỉ làm việc với UseCase, không cần biết bên dưới là repository gì.
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<String> call({
    required LoginParams params,
  }) {
    return repository.login(
      params: params,
    );
  }
}

