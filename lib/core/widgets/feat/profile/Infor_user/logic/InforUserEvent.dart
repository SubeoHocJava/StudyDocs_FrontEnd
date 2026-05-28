import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studydocs/data/model/user/User.dart';

abstract class InforUserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Load thông tin user
class LoadUserInfor extends InforUserEvent {
  final User user;

  LoadUserInfor(this.user);

  @override
  List<Object?> get props => [user];
}

class OpenSettingDialog extends InforUserEvent {
  OpenSettingDialog();

  @override
  List<Object?> get props => [];
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
