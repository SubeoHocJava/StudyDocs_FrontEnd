import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String phoneNumber;

  /// Optional fields
  final String? gender;
  final DateTime? birthDate;
  final String address;
  final String? avatarUrl;
  final String? school;

  /// Flags
  final bool isVerified;
  final bool isFollowing;

  final int? countFollower;
  final int? countFollowing;
  final int countDocument;
  final int countLike;

  const ProfileEntity({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.gender,
    this.birthDate,
    required this.address,
    this.avatarUrl,
    this.school,
    this.isVerified = false,
    this.isFollowing = false,
    this.countFollower,
    this.countFollowing,
    this.countDocument = 0,
    this.countLike = 0,
  });

  /// copyWith cho domain layer
  ProfileEntity copyWith({
    String? username,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? gender,
    DateTime? birthDate,
    String? address,
    String? avatarUrl,
    String? school,
    bool? isVerified,
    bool? isFollowing,
    int? countFollower,
    int? countFollowing,
    int? countDocument,
    int? countLike,
  }) {
    return ProfileEntity(
      id: id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      school: school ?? this.school,
      isVerified: isVerified ?? this.isVerified,
      isFollowing: isFollowing ?? this.isFollowing,
      countFollower: countFollower ?? this.countFollower,
      countFollowing: countFollowing ?? this.countFollowing,
      countDocument: countDocument ?? this.countDocument,
      countLike: countLike ?? this.countLike,
    );
  }

  @override
  List<Object?> get props => [
    id,
    username,
    fullName,
    email,
    phoneNumber,
    gender,
    birthDate,
    address,
    avatarUrl,
    school,
    isVerified,
    isFollowing,
    countFollower,
    countFollowing,
    countDocument,
    countLike,
  ];
}
