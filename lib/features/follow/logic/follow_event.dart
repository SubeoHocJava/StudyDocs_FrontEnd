import 'package:equatable/equatable.dart';

abstract class FollowEvent extends Equatable {
  const FollowEvent();

  @override
  List<Object> get props => [];
}

class LoadFollowLists extends FollowEvent {}

class FollowUser extends FollowEvent {
  final String userId;
  const FollowUser(this.userId);
}

class UnfollowUser extends FollowEvent {
  final String userId;
  const UnfollowUser(this.userId);
}

class RemoveFollower extends FollowEvent {
  final String userId;
  const RemoveFollower(this.userId);
}
