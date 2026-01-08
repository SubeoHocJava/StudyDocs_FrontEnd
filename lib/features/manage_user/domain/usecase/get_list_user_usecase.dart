import '../repository/manage_user_repository.dart';
import 'package:studydocs/data/model/user.dart';

class GetListUserUseCase {
  final ManageUserRepository repository;

  GetListUserUseCase(this.repository);

  Future<List<UserModel>> call({
    required int fromPage,
    required int toPage,
    required int numUser,
  }) {
    return repository.getListUserPage(fromPage, toPage, numUser);
  }
}
