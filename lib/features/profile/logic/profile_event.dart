import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

/// =======================
/// PROFILE EVENT
/// =======================
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// =======================
/// LOAD / REFRESH PROFILE
/// =======================

/// Load profile lần đầu
class LoadProfile extends ProfileEvent {
  final String userId;

  const LoadProfile(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Refresh profile
class RefreshProfile extends ProfileEvent {
  final String userId;

  const RefreshProfile(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// =======================
/// UPDATE PROFILE
/// =======================

/// Update profile info
class UpdateProfile extends ProfileEvent {
  final String userName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? gender;
  final DateTime? birthDate;
  final String address;
  final String? school;

  const UpdateProfile({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.gender,
    this.birthDate,
    required this.address,
    this.school,
  });

  @override
  List<Object?> get props => [
    userName,
    fullName,
    email,
    phoneNumber,
    gender,
    birthDate,
    address,
    school,
  ];
}



class UpdateAvatar extends ProfileEvent {
  final PlatformFile file;

  const UpdateAvatar(this.file);

  @override
  List<Object?> get props => [file];
}


/// Verify email
class VerifyEmail extends ProfileEvent {
  const VerifyEmail();
}

/// Follow user
class FollowUser extends ProfileEvent {
  final String userId;
  const FollowUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Unfollow user
class UnfollowUser extends ProfileEvent {
  final String userId;
  const UnfollowUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// =======================
/// DOCUMENT ACTION EVENTS
/// (TỪ ListDocument CALLBACK)
/// =======================

/// Download document
class DownloadDocumentRequested extends ProfileEvent {
  final String documentId;

  const DownloadDocumentRequested(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

/// Save document
class SaveDocumentRequested extends ProfileEvent {
  final String documentId;

  const SaveDocumentRequested(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

/// Like document
class LikeDocumentRequested extends ProfileEvent {
  final String documentId;

  const LikeDocumentRequested(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

/// Open comment screen / bottom sheet
class OpenCommentRequested extends ProfileEvent {
  final String documentId;

  const OpenCommentRequested(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

/// =======================
/// CLEAR ONE-SHOT STATE
/// =======================

/// Clear success / failure / toast state
class ClearProfileActionState extends ProfileEvent {
  const ClearProfileActionState();
}
