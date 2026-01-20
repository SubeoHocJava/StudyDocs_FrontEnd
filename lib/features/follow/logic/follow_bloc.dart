import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/follow/domain/repository/follow_repository.dart';
import 'follow_event.dart';
import 'follow_state.dart';

import 'package:studydocs/services/token_storage_service.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final FollowRepository repository;

  FollowBloc(this.repository) : super(FollowInitial()) {
    on<LoadFollowLists>(_onLoadFollowLists);
    on<FollowUser>(_onFollowUser);
    on<UnfollowUser>(_onUnfollowUser);
    on<RemoveFollower>(_onRemoveFollower);
  }

  Future<void> _onLoadFollowLists(
    LoadFollowLists event,
    Emitter<FollowState> emit,
  ) async {
    emit(FollowLoading());
    try {
      final userId = await TokenStorageService().getUserId();
      if (userId == null) {
        emit(const FollowError("Không tìm thấy thông tin người dùng"));
        return;
      }
      
      final followers = await repository.getFollowers(userId);
      final following = await repository.getFollowing(userId);
      emit(FollowLoaded(followers: followers, following: following));
    } catch (e) {
      emit(FollowError(e.toString()));
    }
  }

  Future<void> _onFollowUser(
    FollowUser event,
    Emitter<FollowState> emit,
  ) async {
    // Optimistic update or reload. For simplicity: reload
    try {
      await repository.followUser(event.userId);
      add(LoadFollowLists());
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onUnfollowUser(
    UnfollowUser event,
    Emitter<FollowState> emit,
  ) async {
    try {
      await repository.unfollowUser(event.userId);
       add(LoadFollowLists());
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onRemoveFollower(
    RemoveFollower event,
    Emitter<FollowState> emit,
  ) async {
    try {
      await repository.removeFollower(event.userId);
       add(LoadFollowLists());
    } catch (e) {
      // Handle error
    }
  }
}
