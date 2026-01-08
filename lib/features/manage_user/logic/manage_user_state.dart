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

  const ManageUserLoaded({
    required this.listUser,
  });

  ManageUserLoaded copyWith({
    List<UserModel>? listUser,
  }) {
    return ManageUserLoaded(
      listUser: listUser ?? this.listUser,
    );
  }

  @override
  List<Object?> get props => [listUser];
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
