import '../repository/infor_user_repository.dart';

class FollowUserUseCase {
  final InforUserRepository repo;
  FollowUserUseCase(this.repo);

  Future<bool> call(String userId) {
    return repo.followUser(userId);
  }
}