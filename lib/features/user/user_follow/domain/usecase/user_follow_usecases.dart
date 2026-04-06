import '../entity/user_follow_entity.dart';
import '../repository/user_follow_repository.dart';

class GetFollowersUseCase {
  final UserFollowRepository repository;
  GetFollowersUseCase(this.repository);

  Future<List<UserFollowEntity>> call(String userId) {
    return repository.getFollowers(userId);
  }
}

class GetFollowingUseCase {
  final UserFollowRepository repository;
  GetFollowingUseCase(this.repository);

  Future<List<UserFollowEntity>> call(String userId) {
    return repository.getFollowing(userId);
  }
}

class FollowUserUseCase {
  final UserFollowRepository repository;
  FollowUserUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.followUser(userId);
  }
}

class UnfollowUserUseCase {
  final UserFollowRepository repository;
  UnfollowUserUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.unfollowUser(userId);
  }
}

class RemoveFollowerUseCase {
  final UserFollowRepository repository;
  RemoveFollowerUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.removeFollower(userId);
  }
}
