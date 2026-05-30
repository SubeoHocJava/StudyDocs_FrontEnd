import 'package:studydocs/core/constants/api/user_api.dart';
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/model/user/User.dart';

import '../../../core/network/dio_client.dart';

class UserDatasourceImpl implements UserDataSource {
  final DioClient dioClient;

  UserDatasourceImpl({DioClient? client}) : dioClient = client ?? DioClient();

  @override
  Future<User> getUser() async {
    final apiResponse = await dioClient.get(UserEndpoints.me);
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      throw Exception('Không lấy được thông tin người dùng');
    }
    return User.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
