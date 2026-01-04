import '../repository/manage_user_repository.dart';
import 'package:studydocs/data/model/user.dart';

class UpdateUserUseCase {
  final ManageUserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<bool> call(UserModel user) {
    return repository.editUser(user);
  }
}
