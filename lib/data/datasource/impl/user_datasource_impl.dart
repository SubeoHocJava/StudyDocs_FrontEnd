import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/model/user/User.dart';

import '../../../core/constants/api/user_api.dart';
import '../../../core/network/dio_client.dart';

class UserDatasourceImpl implements UserDataSource {
  final String path = UserEndpoints.base;
  final DioClient dioClient;

  UserDatasourceImpl({DioClient? client}) : dioClient = client ?? DioClient();

  @override
  Future<User> getUser() async {
    final apiresponse = await dioClient.post(path,data:{  "username": "admin2",
      "password": "password"} );

    return User.fromJson(apiresponse.data as Map<String, dynamic>);
  }
}
