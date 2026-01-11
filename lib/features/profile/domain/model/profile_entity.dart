class ProfileEntity {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String gender;
  final DateTime? birthDate;
  final String address;
  final String avatarUrl;
  final bool isVerified;
  final bool isFollowing;
  final String? school;

  const ProfileEntity({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    this.birthDate,
    required this.address,
    required this.avatarUrl,
    required this.isVerified,
    this.isFollowing = false,
    this.school,
  });
}
