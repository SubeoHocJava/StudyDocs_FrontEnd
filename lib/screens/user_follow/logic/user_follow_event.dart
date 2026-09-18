import 'package:equatable/equatable.dart';

abstract class UserFollowEvent extends Equatable {
  const UserFollowEvent();

  @override
  List<Object> get props => [];
}

class LoadUserFollowLists extends UserFollowEvent {
  final String userId;
  const LoadUserFollowLists(this.userId);
}

class UserFollowUserEvent extends UserFollowEvent {
  final String userId;
  const UserFollowUserEvent(this.userId);
}

class UnfollowUserEvent extends UserFollowEvent {
  final String userId;
  const UnfollowUserEvent(this.userId);
}

class RemoveUserFollowerEvent extends UserFollowEvent {
  final String userId;
  const RemoveUserFollowerEvent(this.userId);
}
