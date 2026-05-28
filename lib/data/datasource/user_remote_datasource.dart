
import '../model/user/User.dart';

abstract interface class UserDataSource {
  Future<User> getUser();
}