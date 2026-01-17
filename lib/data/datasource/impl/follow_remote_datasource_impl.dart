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
      ApiConstants.follows,
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
    await dioClient.delete(
      ApiConstants.follows,
      queryParameters: {
        'followerId': followerId,
        'followingId': followingId,
      },
    );
  }

  @override
  Future<List<FollowModel>> getFollowers(String userId) async {
    final response = await dioClient.get('${ApiConstants.follows}/$userId');

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
    final response = await dioClient.get('${ApiConstants.followsFollowing}/$userId');

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
    final response = await dioClient.get('${ApiConstants.followsFollowers}/$userId/count');

    if (response.isSuccess && response.data != null) {
      final data = response.data;
      if (data is int) return data;
      if (data is String) return int.tryParse(data) ?? 0;
    }
    return 0;
  }

  @override
  Future<int> countFollowing(String userId) async {
    final response = await dioClient.get('${ApiConstants.followsFollowing}/$userId/count');

    if (response.isSuccess && response.data != null) {
      final data = response.data;
      if (data is int) return data;
      if (data is String) return int.tryParse(data) ?? 0;
    }
    return 0;
  }
}
