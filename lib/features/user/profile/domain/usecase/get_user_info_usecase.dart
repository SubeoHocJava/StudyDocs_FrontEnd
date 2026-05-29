import '../../../../../data/model/user/User.dart';
import '../repository/user_repository.dart';

class GetUserInfoUseCase {
  final UserRepository userRepository;

  GetUserInfoUseCase({required this.userRepository});

  Future<User> call() {
    return userRepository.getUser();
  }
}
