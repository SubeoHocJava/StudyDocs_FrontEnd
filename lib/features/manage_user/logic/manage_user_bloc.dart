import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/data/model/user.dart';

import '../domain/repository/manage_user_repository.dart';
import '../domain/usecase/add_user_usecase.dart';
import '../domain/usecase/delete_user_usecase.dart';
import '../domain/usecase/get_list_user_usecase.dart';
import '../domain/usecase/search_user_usecase.dart';
import '../domain/usecase/update_user_usecase.dart';
import 'manage_user_event.dart';
import 'manage_user_state.dart';

class ManageUserBloc extends Bloc<ManageUserEvent, ManageUserState> {
  final ManageUserRepository repository;

  late final GetListUserUseCase _getListUserUseCase;
  late final DeleteUserUseCase _deleteUserUseCase;
  late final AddUserUseCase _addUserUseCase;
  late final UpdateUserUseCase _updateUserUseCase;
  late final SearchUserUseCase _searchUserUseCase;

  ManageUserBloc(this.repository) : super(ManageUserInitial()) {
    _getListUserUseCase = GetListUserUseCase(repository);
    _deleteUserUseCase = DeleteUserUseCase(repository);
    _addUserUseCase = AddUserUseCase(repository);
    _updateUserUseCase = UpdateUserUseCase(repository);
    _searchUserUseCase = SearchUserUseCase(repository);

    // ================= LOAD USER LIST =================
    on<LoadListUser>(_onLoadListUser);

    // ================= SEARCH USER =================
    on<SearchUser>(_onSearchUser);

    // ================= ADD USER =================
    on<AddUser>(_onAddUser);

    // ================= UPDATE USER =================
    on<UpdateUser>(_onUpdateUser);

    // ================= DELETE USER =================
    on<DeleteUser>(_onDeleteUser);
  }

  // ==================================================
  // HANDLERS
  // ==================================================

  Future<void> _onLoadListUser(
      LoadListUser event,
      Emitter<ManageUserState> emit,
      ) async {
    emit(ManageUserLoading());
    try {
      final users = await _getListUserUseCase(
        fromPage: event.fromPage,
        toPage: event.toPage,
        numUser: event.numUser,
      );

      emit(ManageUserLoaded(listUser: users));
    } catch (e) {
      emit(ManageUserError('Không thể tải danh sách user: $e'));
    }
  }

  Future<void> _onSearchUser(
      SearchUser event,
      Emitter<ManageUserState> emit,
      ) async {
    emit(ManageUserLoading());
    try {
      final users = await _searchUserUseCase(
        fromPage: event.fromPage,
        toPage: event.toPage,
        username: event.username,
      );

      emit(ManageUserLoaded(listUser: users));
    } catch (e) {
      emit(ManageUserError('Không thể tìm user: $e'));
    }
  }

  Future<void> _onAddUser(
      AddUser event,
      Emitter<ManageUserState> emit,
      ) async {
    emit(ManageUserLoading());
    try {
      final success = await _addUserUseCase(event.userId);

      if (!success) {
        emit(const ManageUserError('Thêm user thất bại'));
        return;
      }

      // reload list
      final users = await _getListUserUseCase(fromPage: 1,toPage: 3,numUser: 10);
      emit(ManageUserLoaded(listUser: users));
    } catch (e) {
      emit(ManageUserError('Thêm user thất bại: $e'));
    }
  }

  Future<void> _onUpdateUser(
      UpdateUser event,
      Emitter<ManageUserState> emit,
      ) async {
    emit(ManageUserLoading());
    try {
      final success = await _updateUserUseCase(event.user);

      if (!success) {
        emit(const ManageUserError('Cập nhật user thất bại'));
        return;
      }

      final users = await _getListUserUseCase(fromPage: 1,toPage: 3,numUser: 10);
      emit(ManageUserLoaded(listUser: users));
    } catch (e) {
      emit(ManageUserError('Cập nhật user thất bại: $e'));
    }
  }

  Future<void> _onDeleteUser(
      DeleteUser event,
      Emitter<ManageUserState> emit,
      ) async {
    emit(ManageUserLoading());
    try {
      final success = await _deleteUserUseCase(event.userId);
      if (!success) {
        emit(const ManageUserError('Xóa user thất bại'));
        return;
      }
      final users = await _getListUserUseCase(fromPage: 1,toPage: 3,numUser: 10);
      print('Bloc users length = ${users.length}');
      emit(ManageUserLoaded(listUser: users));
    } catch (e) {
      emit(ManageUserError('Xóa user thất bại: $e'));
    }
  }
}
