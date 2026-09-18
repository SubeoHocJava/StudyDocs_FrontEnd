import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/network/token_services.dart';
import '../domain/repository/user_follow_repository.dart';
import 'user_follow_event.dart';
import 'user_follow_state.dart';



class UserFollowBloc extends Bloc<UserFollowEvent, UserFollowState> {
  final UserFollowRepository repository;

  UserFollowBloc(this.repository) : super(UserFollowInitial()) {
    on<LoadUserFollowLists>(_onLoadUserFollowLists);
    on<UserFollowUserEvent>(_onUserFollowUser);
    on<UnfollowUserEvent>(_onUnfollowUser);
    on<RemoveUserFollowerEvent>(_onRemoveFollower);
  }

  String _currentUserId = "";

  Future<void> _onLoadUserFollowLists(
    LoadUserFollowLists event,
    Emitter<UserFollowState> emit,
  ) async {
    emit(UserFollowLoading());
    try {
      _currentUserId = event.userId;
      final currentLoggedInUserId = await TokenStorageService().getUserId() ?? "";
      final actualUserId = _currentUserId == "me" ? currentLoggedInUserId : _currentUserId;
      final isOwnProfile = _currentUserId == "me" || (_currentUserId == currentLoggedInUserId && currentLoggedInUserId.isNotEmpty);
      
      final followers = await repository.getFollowers(actualUserId);
      final following = await repository.getFollowing(actualUserId);
      emit(UserFollowLoaded(followers: followers, following: following, isOwnProfile: isOwnProfile));
    } catch (e) {
      emit(UserFollowError(e.toString()));
    }
  }

  Future<void> _onUserFollowUser(
    UserFollowUserEvent event,
    Emitter<UserFollowState> emit,
  ) async {
    // Optimistic update or reload. For simplicity: reload
    try {
      await repository.followUser(event.userId);
      add(LoadUserFollowLists(_currentUserId));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onUnfollowUser(
    UnfollowUserEvent event,
    Emitter<UserFollowState> emit,
  ) async {
    try {
      await repository.unfollowUser(event.userId);
       add(LoadUserFollowLists(_currentUserId));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onRemoveFollower(
    RemoveUserFollowerEvent event,
    Emitter<UserFollowState> emit,
  ) async {
    try {
      await repository.removeFollower(event.userId);
       add(LoadUserFollowLists(_currentUserId));
    } catch (e) {
      // Handle error
    }
  }
}
