import 'package:file_picker/file_picker.dart';
import '../repository/infor_user_repository.dart';

class UpdateAvatarUseCase {
  final InforUserRepository repo;

  UpdateAvatarUseCase(this.repo);

  Future<String> call(PlatformFile file) {
    return repo.updateAvatar(file);
  }
}