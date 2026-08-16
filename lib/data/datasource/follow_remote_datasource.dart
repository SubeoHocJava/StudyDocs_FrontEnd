abstract interface class FollowRemoteDataSource {
  Future<void> followUser(String userId);
  Future<void> unfollowUser(String userId);
}
