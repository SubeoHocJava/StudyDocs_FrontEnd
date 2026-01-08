import '../repository/manage_user_repository.dart';

class AddUserUseCase {
  final ManageUserRepository repository;

  AddUserUseCase(this.repository);

  Future<bool> call(String userId) {
    return repository.addUser(userId);
  }
}
