import '../model/profile_entity.dart';

abstract class ProfileRepository {
  /// Lấy thông tin profile hiện tại
  Future<ProfileEntity> getProfile(int userId);

  /// Cập nhật thông tin profile (không bao gồm avatar)
  Future<ProfileEntity> updateProfile(ProfileEntity profile);

  /// Cập nhật avatar
  Future<String> updateAvatar(String imagePath);

  /// Xác thực email
  Future<void> verifyEmail();

  /// Theo dõi người dùng
  Future<void> followUser(String userId);

  /// Bỏ theo dõi người dùng
  Future<void> unfollowUser(String userId);

  getDocumentsByUser(String id) {}


}