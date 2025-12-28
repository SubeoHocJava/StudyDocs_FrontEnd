

import 'package:studydocs/features/profile/domain/model/profile_entity.dart';

import '../repository/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<ProfileEntity> call(Map<String, dynamic> data) {
    return repository.updateProfile(data as ProfileEntity);
  }
}
