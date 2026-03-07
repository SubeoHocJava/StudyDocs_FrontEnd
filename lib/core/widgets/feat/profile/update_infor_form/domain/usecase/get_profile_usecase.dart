
import '../model/UserProfile.dart';
import '../repository/UpdateInforRepository.dart';

class GetProfileUseCase {
  final UpdateInforRepository repository;

  GetProfileUseCase(this.repository);

  Future< UserProfile> call() async {
    return await repository.getProfile();
  }
}
