import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Sự kiện load thông tin profile từ API
class LoadProfile extends ProfileEvent {
  final int userId;

  const LoadProfile(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Sự kiện update profile
class UpdateProfile extends ProfileEvent {
  final String userName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? gender;
  final DateTime? birthDate;
  final String address;

  const UpdateProfile( {
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
