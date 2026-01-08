import '../repository/manage_user_repository.dart';
import 'package:studydocs/data/model/user.dart';

class SearchUserUseCase {
  final ManageUserRepository repository;

  SearchUserUseCase(this.repository);

  Future<List<UserModel>> call({
    required int fromPage,
    required int toPage,
    required String username,
  }) {
    return repository.findUserPage(fromPage, toPage, username);
  }
}
