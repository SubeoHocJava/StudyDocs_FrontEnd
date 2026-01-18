import 'package:studydocs/features/profile/domain/model/profile_entity.dart';

import '../repository/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<ProfileEntity> call(String userId) async {
    return await repository.getProfile(userId);
  }
}
