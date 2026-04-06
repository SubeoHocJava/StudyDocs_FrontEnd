
import '../../entity/user_follow_entity.dart';
import '../user_follow_repository.dart';

class UserFollowRepositoryImpl implements UserFollowRepository {
  @override
  Future<List<UserFollowEntity>> getFollowers(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      const UserFollowEntity(id: '1', name: 'Hảo há cảo', isFollowing: true, avatarUrl: 'https://i.pravatar.cc/150?u=1'),
      const UserFollowEntity(id: '2', name: 'Hiển nem nướng', isFollowing: false, avatarUrl: 'https://i.pravatar.cc/150?u=2'),
      const UserFollowEntity(id: '3', name: 'Dũng bò né', isFollowing: true, avatarUrl: 'https://i.pravatar.cc/150?u=3'),
      const UserFollowEntity(id: '6', name: 'Thanh Trà', isFollowing: false, avatarUrl: 'https://i.pravatar.cc/150?u=6'),
      const UserFollowEntity(id: '7', name: 'Phước Thịnh', isFollowing: true, avatarUrl: 'https://i.pravatar.cc/150?u=7'),
      const UserFollowEntity(id: '8', name: 'Ngọc Lan', isFollowing: false, avatarUrl: 'https://i.pravatar.cc/150?u=8'),
      const UserFollowEntity(id: '9', name: 'Đức Phát', isFollowing: true, avatarUrl: 'https://i.pravatar.cc/150?u=9'),
      const UserFollowEntity(id: '10', name: 'Phương Thảo', isFollowing: false),
    ];
  }

  @override
  Future<List<UserFollowEntity>> getFollowing(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      const UserFollowEntity(id: '4', name: 'Duy mặc váy', isFollowing: true, avatarUrl: 'https://i.pravatar.cc/150?u=4'),
      const UserFollowEntity(id: '5', name: 'Nguyễn Văn Hảo', isFollowing: true, avatarUrl: 'https://i.pravatar.cc/150?u=5'),
      const UserFollowEntity(id: '11', name: 'Tuấn Anh', isFollowing: true, avatarUrl: 'https://i.pravatar.cc/150?u=11'),
      const UserFollowEntity(id: '12', name: 'Hải Linh', isFollowing: true, avatarUrl: 'https://i.pravatar.cc/150?u=12'),
      const UserFollowEntity(id: '13', name: 'Minh Hoàng', isFollowing: true, avatarUrl: 'https://i.pravatar.cc/150?u=13'),
      const UserFollowEntity(id: '14', name: 'Quốc Bảo', isFollowing: true),
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
