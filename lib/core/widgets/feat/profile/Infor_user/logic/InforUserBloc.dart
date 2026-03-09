import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';

import '../domain/repository/impl/infor_user_repository_impl.dart';
import '../domain/usecae/follow_user_usecase.dart';
import '../domain/usecae/get_user_infor_usecase.dart';
import '../domain/usecae/unfollow_user_usecase.dart';
import '../domain/usecae/update_avatar_usecase.dart';

import 'InforUserEvent.dart';
import 'InforUserState.dart';

class InforUserBloc extends Bloc<InforUserEvent, InforUserState> {
  late final GetUserInforUseCase _getUserInforUseCase;
  late final UpdateAvatarUseCase _updateAvatarUseCase;
  late final FollowUserUseCase _followUserUseCase;
  late final UnfollowUserUseCase _unfollowUserUseCase;

  InforUserBloc() : super(InforUserInitial()) {
    // Khởi tạo Repository
    final repo = InforUserRepositoryMock();

    // Khởi tạo UseCase
    _getUserInforUseCase = GetUserInforUseCase(repo);
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
  void _onOpensetting(
      OpenSettingDialog event,
      Emitter<InforUserState> emit,
      ) {
    emit(OpenSettingDialogState());
  }
  /// ================= LOAD USER =================
  Future<void> _onLoadUserInfor(
      LoadUserInfor event, Emitter<InforUserState> emit) async {
    emit(InforUserLoading());
    try {
      final data = await _getUserInforUseCase(event.userId);
      emit(InforUserLoaded(
        id: data.id,
        fullName: data.fullName,
        school: data.school,
        avatarUrl: data.avatarUrl,
        isFollowing: data.isFollowing,
        isOwnProfile: data.isOwnProfile,
      ));
    } catch (e) {
      emit(InforUserError(e.toString()));
    }
  }

  /// ================= UPDATE AVATAR =================
  Future<void> _onUpdateAvatar(
      UpdateUserAvatar event, Emitter<InforUserState> emit) async {
    if (state is! InforUserLoaded) return;

    final current = state as InforUserLoaded;

    try {
      final newAvatar = await _updateAvatarUseCase(event.file);

      emit(current.copyWith(avatarUrl: newAvatar));
    } catch (e) {
      emit(InforUserError("Không thể cập nhật avatar"));
    }
  }

  /// ================= FOLLOW =================
  Future<void> _onFollowUser(
      FollowUserEvent event, Emitter<InforUserState> emit) async {
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
      UnfollowUserEvent event, Emitter<InforUserState> emit) async {
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