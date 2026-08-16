import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/constants/api/user_api.dart';
import '../user_remote_datasource.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _client;

  UserRemoteDataSourceImpl({DioClient? client}) : _client = client ?? DioClient();

  @override
  Future<dynamic> getUser() async {
    final response = await _client.get(UserEndpoints.me);
    if (response.isSuccess && response.data != null) {
      return response.data;
    }
    throw Exception('Failed to load user profile');
  }

  @override
  Future<dynamic> updateUser(Map<String, dynamic> data) async {
    final response = await _client.patch(UserEndpoints.me, data: data);
    if (response.isSuccess) {
      return response.data;
    }
    throw Exception('Failed to update user profile');
  }
}
