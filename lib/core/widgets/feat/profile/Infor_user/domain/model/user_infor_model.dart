class UserInforModel {
  final String id;
  final String fullName;
  final String? school;
  final String? avatarUrl;
  final bool isFollowing;
  final bool isOwnProfile;

  UserInforModel({
    required this.id,
    required this.fullName,
    required this.school,
    required this.avatarUrl,
    required this.isFollowing,
    required this.isOwnProfile,
  });
}