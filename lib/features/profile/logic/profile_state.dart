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
  final Map<String, dynamic> profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Xảy ra lỗi
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
