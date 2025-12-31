import '../entity/user_follow_entity.dart';
import '../repository/follow_repository.dart';

class GetFollowersUseCase {
  final FollowRepository repository;
  GetFollowersUseCase(this.repository);

  Future<List<UserFollowEntity>> call(String userId) {
    return repository.getFollowers(userId);
  }
}

class GetFollowingUseCase {
  final FollowRepository repository;
  GetFollowingUseCase(this.repository);

  Future<List<UserFollowEntity>> call(String userId) {
    return repository.getFollowing(userId);
  }
}

class FollowUserUseCase {
  final FollowRepository repository;
  FollowUserUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.followUser(userId);
  }
}

class UnfollowUserUseCase {
  final FollowRepository repository;
  UnfollowUserUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.unfollowUser(userId);
  }
}

class RemoveFollowerUseCase {
  final FollowRepository repository;
  RemoveFollowerUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.removeFollower(userId);
  }
}
