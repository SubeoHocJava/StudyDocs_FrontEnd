import '../repository/manage_user_repository.dart';

class DeleteUserUseCase {
  final ManageUserRepository repository;

  DeleteUserUseCase(this.repository);

  Future<bool> call(String userId) {
    return repository.deleteUser(userId);
  }
}
