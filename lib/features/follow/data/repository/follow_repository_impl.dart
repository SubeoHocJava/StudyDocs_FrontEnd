import 'package:studydocs/features/follow/domain/entity/user_follow_entity.dart';
import 'package:studydocs/features/follow/domain/repository/follow_repository.dart';

class FollowRepositoryImpl implements FollowRepository {
  @override
  Future<List<UserFollowEntity>> getFollowers(String userId) async {
    // Mock data for demonstration
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      const UserFollowEntity(id: '1', name: 'Hảo há cảo', isFollowing: true),
      const UserFollowEntity(id: '2', name: 'Hiển nem nướng', isFollowing: false),
      const UserFollowEntity(id: '3', name: 'Dũng bò né', isFollowing: true),
      const UserFollowEntity(id: '4', name: 'Duy mặc váy', isFollowing: true),
    ];
  }

  @override
  Future<List<UserFollowEntity>> getFollowing(String userId) async {
    // Mock data for demonstration
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      const UserFollowEntity(id: '5', name: 'Nguyễn Văn Hảo', isFollowing: true),
      const UserFollowEntity(id: '6', name: 'Huỳnh Minh Hiển', isFollowing: true),
      const UserFollowEntity(id: '7', name: 'Lý Tuấn Dũng', isFollowing: true),
      const UserFollowEntity(id: '8', name: 'Lâm Bảo Duy', isFollowing: true),
    ];
  }

  @override
  Future<void> followUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> unfollowUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> removeFollower(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
