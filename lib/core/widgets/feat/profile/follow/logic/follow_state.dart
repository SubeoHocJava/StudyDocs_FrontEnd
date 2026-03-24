import '../domain/models/follow_entity.dart';

abstract class FollowState {}

class FollowInitialState extends FollowState {}

class FollowLoadingState extends FollowState {}

class FollowLoadedState extends FollowState {
  final FollowEntity followData;

  FollowLoadedState(this.followData);
}

class FollowErrorState extends FollowState {
  final String message;

  FollowErrorState(this.message);
}
