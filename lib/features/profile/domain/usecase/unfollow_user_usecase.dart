import '../repository/profile_repository.dart';

class UnfollowUserUseCase {
  final ProfileRepository repository;

  UnfollowUserUseCase(this.repository);

  Future<int> call(String userId) async {
    return await repository.unfollowUser(userId);
  }
}
