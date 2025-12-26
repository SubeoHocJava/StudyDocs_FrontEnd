import 'package:equatable/equatable.dart';
import 'package:studydocs/data/model/document_model.dart';

import '../domain/model/document_profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Ban đầu (chưa load)
class ProfileInitial extends ProfileState {}

/// Đang load dữ liệu
class ProfileLoading extends ProfileState {}

/// Load thành công
class ProfileLoaded extends ProfileState {
  final String id;
  final String userName;
  final String fullName;
  final String school;
  final String email;
  final String phoneNumber;
  final String? gender;
  final DateTime? birthDate;
  final String address;
  final String? avatarUrl;
  final bool isVerified;
  final int numFollowMe;
  final int numMeFollow;
  final int numMyUpload;
  final int numMyLikes;
  final int numMyComment;
  final List<DocumentProfile>documents;

  /// UI flags
  final bool isUpdating;

  const ProfileLoaded({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.school,
    required this.email,
    required this.phoneNumber,
    this.gender,
    this.birthDate,
    required this.address,
    this.avatarUrl,
    this.isVerified = false,
    this.isUpdating = false,
    this.numFollowMe=0,
    this.numMeFollow=0,
    this.numMyUpload=4,
    this.numMyLikes=2,
    this.numMyComment=15,
    required this.documents,
  });

  /// copyWith để update từng field
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
    bool? isUpdating,
    List? documents,
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
      isUpdating: isUpdating ?? this.isUpdating,
      documents: this.documents,
    );
  }

  @override
  List<Object?> get props =>
      [
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
        isUpdating,
        documents,
      ];

}


/// Xảy ra lỗi
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;

  const ProfileUpdateSuccess({this.message = "Cập nhật thành công"});

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateFailure extends ProfileState {
  final String message;

  const ProfileUpdateFailure(this.message);

  @override
  List<Object?> get props => [message];
}
