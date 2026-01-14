import '../../../../data/model/auth/response/user_me_response.dart';
import '../repositories/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository repository;

  GoogleLoginUseCase({required this.repository});

  Future<UserMeResponse> call({String? idToken}) {
    return repository.loginWithGoogle(idToken: idToken);
  }
}
