

import 'package:studydocs/features/profile/domain/model/profile_entity.dart';

import '../repository/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<ProfileEntity> call(ProfileEntity profile) {
    return repository.updateProfile(profile);
  }
}
