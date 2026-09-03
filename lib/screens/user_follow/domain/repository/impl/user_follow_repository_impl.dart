
import '../../../../../core/network/dio_client.dart';
import '../../entity/user_follow_entity.dart';
import '../user_follow_repository.dart';

class UserFollowRepositoryImpl implements UserFollowRepository {
  final DioClient _dioClient;

  UserFollowRepositoryImpl({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  @override
  Future<List<UserFollowEntity>> getFollowers(String userId) async {
    final response = await _dioClient.get('/user/followers');
    if (response.data != null) {
      final List<dynamic> data = response.data;
      return data.map((json) => UserFollowEntity(
        id: json['id'],
        name: json['name'],
        isFollowing: json['isFollowing'] ?? false,
        avatarUrl: json['avatarUrl'],
      )).toList();
    }
    return [];
  }

  @override
  Future<List<UserFollowEntity>> getFollowing(String userId) async {
    final response = await _dioClient.get('/user/following');
    if (response.data != null) {
      final List<dynamic> data = response.data;
      return data.map((json) => UserFollowEntity(
        id: json['id'],
        name: json['name'],
        isFollowing: json['isFollowing'] ?? true,
        avatarUrl: json['avatarUrl'],
      )).toList();
    }
    return [];
  }

  @override
  Future<void> followUser(String userId) async {
    await _dioClient.post('/user/$userId/follow');
  }

  @override
  Future<void> unfollowUser(String userId) async {
    await _dioClient.post('/user/$userId/unfollow');
  }

  @override
  Future<void> removeFollower(String userId) async {
    // Currently backend doesn't have a direct removeFollower API by ID, we may need to adapt if exist, otherwise we can ignore for now.
    // Example: await _dioClient.delete('/user/$userId/follower');
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
