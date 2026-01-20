import 'package:studydocs/features/follow/domain/entity/user_follow_entity.dart';
import 'package:studydocs/features/follow/domain/repository/follow_repository.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/services/token_storage_service.dart';
import 'package:studydocs/data/datasource/follow_remote_datasource.dart';
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/follow_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/impl/user_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/impl/asset_remote_datasource_impl.dart';

class FollowRepositoryImpl implements FollowRepository {
  final FollowRemoteDataSource followRemoteDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  FollowRepositoryImpl({
    FollowRemoteDataSource? followDataSource,
    UserRemoteDataSource? userDataSource,
  })  : followRemoteDataSource = followDataSource ??
            FollowRemoteDataSourceImpl(dioClient: DioClient()),
        userRemoteDataSource = userDataSource ??
            UserDataSourceImpl(
              dioClient: DioClient(),
              assetRemoteDataSource:
                  AssetRemoteDataSourceImpl(dioClient: DioClient()),
            );

  @override
  Future<List<UserFollowEntity>> getFollowers(String userId) async {
    try {
      final followModels = await followRemoteDataSource.getFollowers(userId);

      if (followModels.isEmpty) return [];

      final followerIds = followModels
          .map((e) => e.followerId)
          .where((id) => id != null)
          .cast<String>()
          .toList();

      if (followerIds.isEmpty) return [];

      final userFutures = followerIds.map((id) => _fetchUserSafe(id));
      final users = await Future.wait(userFutures);

      return users.whereType<UserFollowEntity>().toList();
    } catch (e) {
      print('FollowRepository error: $e');
      return [];
    }
  }

  @override
  Future<List<UserFollowEntity>> getFollowing(String userId) async {
    try {
      final followModels = await followRemoteDataSource.getFollowing(userId);

      if (followModels.isEmpty) return [];

      final followingIds = followModels
          .map((e) => e.followingId)
          .where((id) => id != null)
          .cast<String>()
          .toList();

      if (followingIds.isEmpty) return [];

      final userFutures = followingIds.map((id) => _fetchUserSafe(id));
      final users = await Future.wait(userFutures);

      return users.whereType<UserFollowEntity>().toList();
    } catch (e) {
      print('FollowRepository error: $e');
      return [];
    }
  }

  Future<UserFollowEntity?> _fetchUserSafe(String userId) async {
    try {
      final response = await userRemoteDataSource.getUserById(userId);
      if (response.isSuccess && response.data != null) {
        final data = response.data;
        return UserFollowEntity(
          id: data['id']?.toString() ?? userId,
          name: data['fullName'] ?? 'Người dùng $userId',
          avatarUrl: data['avatarUrl'],
          isFollowing: true,
        );
      }
    } catch (e) {
      print('Failed to fetch user $userId: $e');
    }
    return null;
  }

  @override
  Future<void> followUser(String userId) async {
    final myId = await _getMyUserId();
    if (myId == null) throw Exception("Unauthorized");
    await followRemoteDataSource.follow(followerId: myId, followingId: userId);
  }

  @override
  Future<void> unfollowUser(String userId) async {
    final myId = await _getMyUserId();
    if (myId == null) throw Exception("Unauthorized");
    await followRemoteDataSource.deleteFollow(
        followerId: myId, followingId: userId);
  }

  @override
  Future<void> removeFollower(String userId) async {
    final myId = await _getMyUserId();
    if (myId == null) throw Exception("Unauthorized");

    await followRemoteDataSource.deleteFollow(
        followerId: userId, followingId: myId);
  }

  Future<String?> _getMyUserId() async {
    return TokenStorageService().getUserId();
  }
}
