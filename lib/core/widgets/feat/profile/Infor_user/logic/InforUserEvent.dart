import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class InforUserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Load thông tin user
class LoadUserInfor extends InforUserEvent {
  final String userId;
  LoadUserInfor(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Cập nhật avatar
class UpdateUserAvatar extends InforUserEvent {
  final PlatformFile file;

  UpdateUserAvatar(this.file);

  @override
  List<Object?> get props => [file];
}

/// Follow user
class FollowUserEvent extends InforUserEvent {
  final String targetUserId;

  FollowUserEvent(this.targetUserId);

  @override
  List<Object?> get props => [targetUserId];
}

/// Unfollow user
class UnfollowUserEvent extends InforUserEvent {
  final String targetUserId;

  UnfollowUserEvent(this.targetUserId);

  @override
  List<Object?> get props => [targetUserId];
}