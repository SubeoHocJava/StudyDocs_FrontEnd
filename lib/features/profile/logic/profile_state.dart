import 'package:equatable/equatable.dart';
import '../domain/model/document_profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// ================= INITIAL =================
class ProfileInitial extends ProfileState {}

/// ================= LOADING =================
class ProfileLoading extends ProfileState {}

/// ================= LOADED =================
class ProfileLoaded extends ProfileState {
  /// ===== USER INFO =====
  final String id;
  final String userName;
  final String fullName;
  final String? school;
  final String email;
  final String phoneNumber;
  final String? gender;
  final DateTime? birthDate;
  final String address;
  final String? avatarUrl;

  /// ===== VERIFY / FOLLOW =====
  final bool isVerified;
  final bool isFollowing;

  /// ===== STATISTICS =====
  final int? numFollowMe;
  final int? numMeFollow;
  final int numMyUpload;
  final int numMyLikes;
  final int numMyComment;

  /// ===== DOCUMENTS =====
  final List<DocumentProfile> documents;

  /// ===== SCHOOLS (for profile form) =====
  final List<String> schools;

  /// ===== UI FLAGS =====
  final bool isUpdating;

  const ProfileLoaded({
    required this.id,
    required this.userName,
    required this.fullName,
    this.school,
    required this.email,
    required this.phoneNumber,
    this.gender,
    this.birthDate,
    required this.address,
    this.avatarUrl,
    this.isVerified = false,
    this.isFollowing = false,
    this.numFollowMe = 0,
    this.numMeFollow = 0,
    this.numMyUpload = 0,
    this.numMyLikes = 0,
    this.numMyComment = 0,
    required this.documents,
    required this.schools,
    this.isUpdating = false,
  });

  ProfileLoaded copyWith({
    String? userName,
    String? fullName,
    String? school,
    String? email,
    String? phoneNumber,
    String? gender,
    DateTime? birthDate,
    String? address,
    String? avatarUrl,
    bool? isVerified,
    bool? isFollowing,
    bool? isUpdating,
    List<DocumentProfile>? documents,
    List<String>? schools,
    int? numFollowMe,
    int? numMeFollow,
    int? numMyUpload,
    int? numMyLikes,
    int? numMyComment,
  }) {
    return ProfileLoaded(
      id: id,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      school: school ?? this.school,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      isFollowing: isFollowing ?? this.isFollowing,
      isUpdating: isUpdating ?? this.isUpdating,
      documents: documents ?? this.documents,
      schools: schools ?? this.schools,
      numFollowMe: numFollowMe ?? this.numFollowMe,
      numMeFollow: numMeFollow ?? this.numMeFollow,
      numMyUpload: numMyUpload ?? this.numMyUpload,
      numMyLikes: numMyLikes ?? this.numMyLikes,
      numMyComment: numMyComment ?? this.numMyComment,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userName,
    fullName,
    school,
    email,
    phoneNumber,
    gender,
    birthDate,
    address,
    avatarUrl,
    isVerified,
    isFollowing,
    documents,
    schools,
    isUpdating,
    numFollowMe,
    numMeFollow,
    numMyUpload,
    numMyLikes,
    numMyComment,
  ];
}

/// ================= ERROR =================
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ================= ACTION STATES =================
class ProfileUpdateSuccess extends ProfileState {
  final String message;

  const ProfileUpdateSuccess({this.message = 'Cập nhật thành công'});

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateFailure extends ProfileState {
  final String message;

  const ProfileUpdateFailure(this.message);

  @override
  List<Object?> get props => [message];
}
