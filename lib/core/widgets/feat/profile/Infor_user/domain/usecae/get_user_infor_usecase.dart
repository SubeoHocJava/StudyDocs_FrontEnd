import '../model/user_infor_model.dart';
import '../repository/infor_user_repository.dart';

class GetUserInforUseCase {
  final InforUserRepository repo;

  GetUserInforUseCase(this.repo);

  Future<UserInforModel> call(String userId) {
    return repo.getUserInfor(userId);
  }
}