import 'package:file_picker/file_picker.dart';

import '../model/profile_entity.dart';
import '../model/document_profile.dart';

abstract class ProfileRepository {
  /// Lấy thông tin profile hiện tại
  Future<ProfileEntity> getProfile(int userId);

  /// Cập nhật thông tin profile (không bao gồm avatar)
  Future<ProfileEntity> updateProfile(ProfileEntity profile);

  /// Cập nhật avatar
  Future<PlatformFile> updateAvatar(PlatformFile imagePath);

  /// Xác thực email
  Future<void> verifyEmail();

  /// Theo dõi người dùng
  Future<int> followUser(String userId);

  /// Bỏ theo dõi người dùng
  Future<int> unfollowUser(String userId);

  Future<List<DocumentProfile>> getDocumentsByUser(String id);


}