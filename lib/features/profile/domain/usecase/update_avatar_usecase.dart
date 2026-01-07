

import '../repository/profile_repository.dart';

class UpdateAvatarUseCase {
  final ProfileRepository repository;
  UpdateAvatarUseCase(this.repository);

  Future<String> call(String imagePath) {
    return repository.updateAvatar(imagePath);
  }
}
