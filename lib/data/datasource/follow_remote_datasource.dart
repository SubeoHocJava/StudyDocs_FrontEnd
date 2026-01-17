import '../model/follow_model.dart';

abstract class FollowRemoteDataSource {
  /// Follow a user
  Future<FollowModel> follow({
    required String followerId,
    required String followingId,
  });

  /// Unfollow or remove a follower
  Future<void> deleteFollow({
    required String followerId,
    required String followingId,
  });

  /// Get list of followers
  Future<List<FollowModel>> getFollowers(String userId);

  /// Get list of following
  Future<List<FollowModel>> getFollowing(String userId);

  /// Count followers
  Future<int> countFollowers(String userId);

  /// Count following
  Future<int> countFollowing(String userId);
}
