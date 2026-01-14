import '../repository/profile_repository.dart';

class FollowUserUseCase {
  final ProfileRepository repository;

  FollowUserUseCase(this.repository);

  Future<void> call(String userId) async {
    return await repository.followUser(userId);
  }
}
