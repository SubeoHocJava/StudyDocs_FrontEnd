import '../repository/profile_repository.dart';

class FollowUserUseCase {
  final ProfileRepository repository;

  FollowUserUseCase(this.repository);

  Future<int> call(String userId) async {
    return await repository.followUser(userId);
  }
}
