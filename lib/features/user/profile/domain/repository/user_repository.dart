import '../../../../../data/datasource/user_remote_datasource.dart';
import '../../../../../data/model/user/User.dart';

class UserRepository {
  final UserDataSource userDataSource;

  UserRepository({required this.userDataSource});

  Future<User> getUser() {
    return userDataSource.getUser();
  }
}
