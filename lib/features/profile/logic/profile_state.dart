import 'package:equatable/equatable.dart';

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
  final String userName;
  final String fullName;
  final String school;
  final String email;
  final String phoneNumber;
  final String? gender;
  final DateTime? birthDate;
  final String address;

  const ProfileLoaded({
    required this.userName,
    required this.fullName,
    required this.school,
    required this.email,
    required this.phoneNumber,
    this.gender,
    this.birthDate,
    required this.address,
  });

  @override
  List<Object?> get props => [
    userName,
    fullName,
    school,
    email,
    phoneNumber,
    gender,
    birthDate,
    address,
  ];
}


/// Xảy ra lỗi
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
