import 'package:bloc/bloc.dart';

import '../domain/repository/impl/infor_user_repository_impl.dart';
import '../domain/usecae/follow_user_usecase.dart';
import '../domain/usecae/unfollow_user_usecase.dart';
import '../domain/usecae/update_avatar_usecase.dart';

import 'infor_user_event.dart';
import 'infor_user_state.dart';

class InforUserBloc extends Bloc<InforUserEvent, InforUserState> {
  late final UpdateAvatarUseCase _updateAvatarUseCase;
  late final FollowUserUseCase _followUserUseCase;
  late final UnfollowUserUseCase _unfollowUserUseCase;

  InforUserBloc() : super(InforUserInitial()) {
    // Khởi tạo Repository
    final repo = InforUserRepositoryImpl();

    // Khởi tạo UseCase
    _updateAvatarUseCase = UpdateAvatarUseCase(repo);
    _followUserUseCase = FollowUserUseCase(repo);
    _unfollowUserUseCase = UnfollowUserUseCase(repo);

    // Event handler
    on<LoadUserInfor>(_onLoadUserInfor);
    on<UpdateUserAvatar>(_onUpdateAvatar);
    on<FollowUserEvent>(_onFollowUser);
    on<UnfollowUserEvent>(_onUnfollowUser);
    on<OpenSettingDialog>(_onOpensetting);
  }
  void _onOpensetting(OpenSettingDialog event, Emitter<InforUserState> emit) {
    emit(OpenSettingDialogState());
  }

  /// ================= LOAD USER =================
  Future<void> _onLoadUserInfor(
    LoadUserInfor event,
    Emitter<InforUserState> emit,
  ) async {
    emit(InforUserLoading());
    try {
      final user = event.user;
      final String nameToDisplay =
          (user.fullName != null && user.fullName!.trim().isNotEmpty)
              ? user.fullName!
              : (user.username ?? "");

      emit(
        InforUserLoaded(
          id: user.id ?? "",
          fullName: nameToDisplay,
          school: user.school,
          avatarUrl: user.avatarUrl,
          isFollowing: false,
          isOwnProfile: true, // If we're visiting 'me', this is true
        ),
      );
    } catch (e) {
      emit(InforUserError(e.toString()));
    }
  }

  /// ================= UPDATE AVATAR =================
  Future<void> _onUpdateAvatar(
    UpdateUserAvatar event,
    Emitter<InforUserState> emit,
  ) async {
    if (state is! InforUserLoaded) return;

    final current = state as InforUserLoaded;

    try {
      final newAvatar = await _updateAvatarUseCase(event.file);

      emit(current.copyWith(avatarUrl: newAvatar));
    } catch (e) {
      emit(InforUserError(e.toString()));
    }
  }

  /// ================= FOLLOW =================
  Future<void> _onFollowUser(
    FollowUserEvent event,
    Emitter<InforUserState> emit,
  ) async {
    if (state is! InforUserLoaded) return;
    final current = state as InforUserLoaded;

    try {
      await _followUserUseCase(event.targetUserId);
      emit(current.copyWith(isFollowing: true));
    } catch (e) {
      emit(InforUserError("Follow thất bại"));
    }
  }

  /// ================= UNFOLLOW =================
  Future<void> _onUnfollowUser(
    UnfollowUserEvent event,
    Emitter<InforUserState> emit,
  ) async {
    if (state is! InforUserLoaded) return;
    final current = state as InforUserLoaded;

    try {
      await _unfollowUserUseCase(event.targetUserId);
      emit(current.copyWith(isFollowing: false));
    } catch (e) {
      emit(InforUserError("Unfollow thất bại"));
    }
  }
}
