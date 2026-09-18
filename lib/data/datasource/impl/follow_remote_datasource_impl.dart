import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/constants/api/user_api.dart';
import '../follow_remote_datasource.dart';

class FollowRemoteDataSourceImpl implements FollowRemoteDataSource {
  final DioClient _client;

  FollowRemoteDataSourceImpl({DioClient? client}) : _client = client ?? DioClient();

  @override
  Future<void> followUser(String userId) async {
    final response = await _client.post('${UserEndpoints.base}/$userId/follow');
    if (!response.isSuccess) {
      throw Exception('Failed to follow user');
    }
  }

  @override
  Future<void> unfollowUser(String userId) async {
    final response = await _client.delete('${UserEndpoints.base}/$userId/follow');
    if (!response.isSuccess) {
      throw Exception('Failed to unfollow user');
    }
  }
}
