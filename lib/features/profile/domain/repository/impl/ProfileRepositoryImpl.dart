import 'package:studydocs/features/profile/domain/model/profile_entity.dart';
import 'package:studydocs/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository{
  @override
  Future<ProfileEntity> getProfile(int userId) {
    // TODO: implement getProfile
    throw UnimplementedError();
  }

  @override
  Future<String> updateAvatar(String imagePath) {
    // TODO: implement updateAvatar
    throw UnimplementedError();
  }

  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<void> verifyEmail() {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }

}