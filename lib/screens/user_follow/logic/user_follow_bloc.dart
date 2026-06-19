import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> _onLoadUserFollowLists(
    LoadUserFollowLists event,
    Emitter<UserFollowState> emit,
  ) async {
    emit(UserFollowLoading());
    try {
      final userId = "await TokenStorageService().getUserId()";
      if (userId == null) {
        emit(const UserFollowError("Không tìm thấy thông tin người dùng"));
        return;
      }
      
      final followers = await repository.getFollowers(userId);
      final following = await repository.getFollowing(userId);
      emit(UserFollowLoaded(followers: followers, following: following));
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
      add(LoadUserFollowLists());
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
       add(LoadUserFollowLists());
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
       add(LoadUserFollowLists());
    } catch (e) {
      // Handle error
    }
  }
}
