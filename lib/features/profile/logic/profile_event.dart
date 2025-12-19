import 'package:equatable/equatable.dart';
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load profile lần đầu
class LoadProfile extends ProfileEvent {
  final int userId;
  const LoadProfile(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Refresh profile
class RefreshProfile extends ProfileEvent {
  final int userId;
  const RefreshProfile(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Update profile info
class UpdateProfile extends ProfileEvent {
  final String userName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? gender;
  final DateTime? birthDate;
  final String address;

  const UpdateProfile({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.gender,
    this.birthDate,
    required this.address,
  });

  @override
  List<Object?> get props =>
      [userName, fullName, email, phoneNumber, gender, birthDate, address];
}

/// Update avatar
class UpdateAvatar extends ProfileEvent {
  final String imagePath;
  const UpdateAvatar(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

/// Verify email
class VerifyEmail extends ProfileEvent {
  const VerifyEmail();
}

/// Clear one-shot states (success / failure)
class ClearProfileActionState extends ProfileEvent {
  const ClearProfileActionState();
}
