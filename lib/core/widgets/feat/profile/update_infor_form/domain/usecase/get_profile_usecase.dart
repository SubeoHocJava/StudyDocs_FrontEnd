import '../model/user_profile.dart';
import '../repository/update_infor_repository.dart';

class GetProfileUseCase {
  final UpdateInforRepository repository;

  GetProfileUseCase(this.repository);

  Future<UserProfile> call() async {
    return await repository.getProfile();
  }
}
