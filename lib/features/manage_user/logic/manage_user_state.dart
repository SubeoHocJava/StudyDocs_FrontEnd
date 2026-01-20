import 'package:equatable/equatable.dart';
import 'package:studydocs/data/model/user.dart';

abstract class ManageUserState extends Equatable {
  const ManageUserState();

  @override
  List<Object?> get props => [];
}

/// =======================
/// INITIAL
/// =======================
class ManageUserInitial extends ManageUserState {}

/// =======================
/// LOADING
/// =======================
class ManageUserLoading extends ManageUserState {}

/// =======================
/// LOAD LIST USER SUCCESS
/// =======================
class ManageUserLoaded extends ManageUserState {
  final List<UserModel> listUser;
  final String? successMessage;

  const ManageUserLoaded({
    required this.listUser,
    this.successMessage,
  });

  ManageUserLoaded copyWith({
    List<UserModel>? listUser,
    String? successMessage,
  }) {
    return ManageUserLoaded(
      listUser: listUser ?? this.listUser,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [listUser, successMessage];
}

/// =======================
/// ERROR
/// =======================
class ManageUserError extends ManageUserState {
  final String message;

  const ManageUserError(this.message);

  @override
  List<Object?> get props => [message];
}
