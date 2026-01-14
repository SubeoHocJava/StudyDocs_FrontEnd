

import 'package:file_picker/file_picker.dart';

import '../repository/profile_repository.dart';

class UpdateAvatarUseCase {
  final ProfileRepository repository;
  UpdateAvatarUseCase(this.repository);

  Future<PlatformFile> call(PlatformFile imagePath) {
    return repository.updateAvatar(imagePath);
  }
}
