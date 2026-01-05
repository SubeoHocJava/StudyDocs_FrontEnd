import 'package:studydocs/features/profile/domain/model/profile_entity.dart';

import '../repository/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);

  Future<ProfileEntity> call(int userId) {
    return repository.getProfile(userId);
  }
}