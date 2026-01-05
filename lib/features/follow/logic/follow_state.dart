import 'package:equatable/equatable.dart';
import 'package:studydocs/features/follow/domain/entity/user_follow_entity.dart';

abstract class FollowState extends Equatable {
  const FollowState();
  
  @override
  List<Object> get props => [];
}

class FollowInitial extends FollowState {}

class FollowLoading extends FollowState {}

class FollowLoaded extends FollowState {
  final List<UserFollowEntity> followers;
  final List<UserFollowEntity> following;

  const FollowLoaded({
    this.followers = const [],
    this.following = const [],
  });

  @override
  List<Object> get props => [followers, following];
  
  FollowLoaded copyWith({
    List<UserFollowEntity>? followers,
    List<UserFollowEntity>? following,
  }) {
    return FollowLoaded(
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}

class FollowError extends FollowState {
  final String message;
  const FollowError(this.message);
  
  @override
  List<Object> get props => [message];
}
