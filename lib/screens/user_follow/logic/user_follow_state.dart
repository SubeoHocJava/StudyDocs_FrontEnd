import 'package:equatable/equatable.dart';

import '../domain/entity/user_follow_entity.dart';

abstract class UserFollowState extends Equatable {
  const UserFollowState();
  
  @override
  List<Object> get props => [];
}

class UserFollowInitial extends UserFollowState {}

class UserFollowLoading extends UserFollowState {}

class UserFollowLoaded extends UserFollowState {
  final List<UserFollowEntity> followers;
  final List<UserFollowEntity> following;
  final bool isOwnProfile;

  const UserFollowLoaded({
    this.followers = const [],
    this.following = const [],
    this.isOwnProfile = false,
  });

  @override
  List<Object> get props => [followers, following, isOwnProfile];
  
  UserFollowLoaded copyWith({
    List<UserFollowEntity>? followers,
    List<UserFollowEntity>? following,
    bool? isOwnProfile,
  }) {
    return UserFollowLoaded(
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isOwnProfile: isOwnProfile ?? this.isOwnProfile,
    );
  }
}

class UserFollowError extends UserFollowState {
  final String message;
  const UserFollowError(this.message);
  
  @override
  List<Object> get props => [message];
}
