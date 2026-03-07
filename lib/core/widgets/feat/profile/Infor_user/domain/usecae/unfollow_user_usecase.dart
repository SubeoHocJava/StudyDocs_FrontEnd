import '../repository/infor_user_repository.dart';

class UnfollowUserUseCase {
  final InforUserRepository repo;
  UnfollowUserUseCase(this.repo);

  Future<bool> call(String userId) {
    return repo.unfollowUser(userId);
  }
}