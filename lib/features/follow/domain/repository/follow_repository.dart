import 'package:studydocs/features/follow/domain/entity/user_follow_entity.dart';

abstract class FollowRepository {
  Future<List<UserFollowEntity>> getFollowers(String userId);
  Future<List<UserFollowEntity>> getFollowing(String userId);
  Future<void> followUser(String userId);
  Future<void> unfollowUser(String userId);
  Future<void> removeFollower(String userId);
}
