import 'package:studydocs/features/follow/domain/entity/user_follow_entity.dart';
import 'package:studydocs/features/follow/domain/repository/follow_repository.dart';

class FollowRepositoryImpl implements FollowRepository {
  @override
  Future<List<UserFollowEntity>> getFollowers(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      const UserFollowEntity(id: '1', name: 'Hảo há cảo', isFollowing: true),
      const UserFollowEntity(id: '2', name: 'Hiển nem nướng', isFollowing: false),
      const UserFollowEntity(id: '3', name: 'Dũng bò né', isFollowing: true),
    ];
  }

  @override
  Future<List<UserFollowEntity>> getFollowing(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      const UserFollowEntity(id: '4', name: 'Duy mặc váy', isFollowing: true),
      const UserFollowEntity(id: '5', name: 'Nguyễn Văn Hảo', isFollowing: true),
    ];
  }

  @override
  Future<void> followUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> unfollowUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> removeFollower(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
