import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/core/network/dio_client.dart';
import '../follow_remote_datasource.dart';
import '../../model/follow_model.dart';

class FollowRemoteDataSourceImpl implements FollowRemoteDataSource {
  final DioClient dioClient;

  FollowRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<FollowModel> follow({
    required String followerId,
    required String followingId,
  }) async {
    final response = await dioClient.post(
      FollowEndpoints.base,
      data: {
        'followerId': followerId,
        'followingId': followingId,
      },
    );

    if (response.isSuccess && response.data != null) {
      // response.data already contains the 'data' field from the raw JSON
      return FollowModel.fromJson(response.data as Map<String, dynamic>);
    }

    throw Exception('Failed to follow user');
  }

  @override
  Future<void> deleteFollow({
    required String followerId,
    required String followingId,
  }) async {
    final response = await dioClient.delete(
      FollowEndpoints.base,
      queryParameters: {
        'followerId': followerId,
        'followingId': followingId,
      },
    );
    print('DELETE unfollow response: ${response.data}');
    print('Type: ${response.data.runtimeType}');
    if (!response.isSuccess) {
      throw Exception('Failed to unfollow user');
    }
  }


  @override
  Future<List<FollowModel>> getFollowers(String userId) async {
    final response = await dioClient.get('${FollowEndpoints.base}/$userId');

    if (response.isSuccess && response.data != null) {
      if (response.data is List) {
        return (response.data as List)
            .map((e) => FollowModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  @override
  Future<List<FollowModel>> getFollowing(String userId) async {
    final response = await dioClient.get('${FollowEndpoints.following}/$userId');

    if (response.isSuccess && response.data != null) {
      if (response.data is List) {
        return (response.data as List)
            .map((e) => FollowModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  @override
  Future<int> countFollowers(String userId) async {
    final response = await dioClient.get('${FollowEndpoints.followers}/$userId/count');

    if (response.isSuccess && response.data != null) {
      final data = response.data;
      if (data is int) return data;
      if (data is String) return int.tryParse(data) ?? 0;
    }
    return 0;
  }

  @override
  Future<int> countFollowing(String userId) async {
    final response = await dioClient.get('${FollowEndpoints.following}/$userId/count');

    if (response.isSuccess && response.data != null) {
      final data = response.data;
      if (data is int) return data;
      if (data is String) return int.tryParse(data) ?? 0;
    }
    return 0;
  }

  //is flollowing
@override
  Future<bool> isFollowing(String followerId, String followingId) async {
    final response = await dioClient.get('${FollowEndpoints.base}/is-following?followerId=$followerId&followingId=$followingId');
    if (response.isSuccess && response.data != null) {
      final data = response.data;
      if (data is bool) return data;
      if (data is String) return data.toLowerCase() == 'true';
    }
    return false;
  }
}
