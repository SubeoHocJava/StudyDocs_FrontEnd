
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/user_remote_datasource_impl.dart';
import '../../../../../data/model/user/User.dart';

class UserRepository {
  final UserRemoteDataSource userDataSource;

  UserRepository({UserRemoteDataSource? dataSource}) 
      : userDataSource = dataSource ?? UserRemoteDataSourceImpl();

  Future<User> getUser() async {
    final userData = await userDataSource.getUser();
    return User.fromJson(userData);
  }

  Future<User> getUserProfile(String userId) async {
    final userData = await userDataSource.getUserProfile(userId);
    return User.fromJson(userData);
  }
}
