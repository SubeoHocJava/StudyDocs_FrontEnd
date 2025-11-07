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
  final Map<String, dynamic> data;

  const UpdateProfile(this.data);

  @override
  List<Object?> get props => [data];
}
