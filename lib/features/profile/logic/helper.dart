import 'package:studydocs/features/profile/logic/profile_state.dart';
import '../../../data/model/user.dart';
import '../domain/model/document_profile.dart';
import '../domain/model/profile_entity.dart';

class HelperMap {
  /// ProfileEntity -> ProfileLoaded (state)

  static ProfileLoaded mapProfileToLoaded({
    required ProfileEntity profile,
    required List<DocumentProfile> documents,
  }) {
    return ProfileLoaded(
      id: profile.id,
      userName: profile.username,
      fullName: profile.fullName,
      school: "profile.school",
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      gender: profile.gender,
      birthDate: profile.birthDate,
      address: profile.address,
      avatarUrl: profile.avatarUrl,
      isVerified: profile.isVerified,
      isFollowing: profile.isFollowing,
      documents: documents,
    );
  }

  /// UserModel -> ProfileEntity
  static ProfileEntity mapUserToProfileEntity(UserModel user) {
    return ProfileEntity(
      id: user.id,
      username: user.username,
      fullName: user.fullName,
      school: null,
      // User không có field này
      email: user.email,
      phoneNumber: user.phoneNumber,
      gender: user.gender,
      birthDate: user.dateOfBirth,
      address: user.address,
      avatarUrl: user.avatarUrl,
      isVerified: false,
    );
  }
}
