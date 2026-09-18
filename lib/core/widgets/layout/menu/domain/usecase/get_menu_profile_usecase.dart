import '../model/menu_profile.dart';
import '../repository/menu_profile_repository.dart';

class GetMenuProfileUseCase {
  final MenuProfileRepository repository;

  GetMenuProfileUseCase(this.repository);

  Future<MenuProfile> execute(String userId) {
    return repository.getMenuProfile(userId);
  }
}
