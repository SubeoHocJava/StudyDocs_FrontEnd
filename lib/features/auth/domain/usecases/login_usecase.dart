import '../../../../data/model/auth/response/user_me_response.dart';
import '../params/login_params.dart';
import '../repositories/auth_repository.dart';

/// UseCase thể hiện 1 "hành động nghiệp vụ" cụ thể: đăng nhập.
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<UserMeResponse> call({
    required LoginParams params,
  }) {
    return repository.login(
      params: params,
    );
  }
}

