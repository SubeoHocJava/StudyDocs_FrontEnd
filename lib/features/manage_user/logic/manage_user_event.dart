import 'package:equatable/equatable.dart';
import '../../../data/model/user.dart';

/// =======================
/// MANAGE USER EVENT
/// =======================
abstract class ManageUserEvent extends Equatable {
  const ManageUserEvent();

  @override
  List<Object?> get props => [];
}

class LoadListUser extends ManageUserEvent {
  final int fromPage;
  final int toPage;
  final int numUser;

  const LoadListUser({
    required this.fromPage,
    required this.toPage,
    required this.numUser,
  });

  @override
  List<Object?> get props => [fromPage, toPage, numUser];
}

class DeleteUser extends ManageUserEvent {
  final String userId;

  const DeleteUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddUser extends ManageUserEvent {
  final String userId;

  const AddUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUser extends ManageUserEvent {
  final UserModel user;

  const UpdateUser(this.user);

  @override
  List<Object?> get props => [user];
}

class SearchUser extends ManageUserEvent {
  final int fromPage;
  final int toPage;
  final String username;

  const SearchUser({
    required this.fromPage,
    required this.toPage,
    required this.username,
  });

  @override
  List<Object?> get props => [fromPage, toPage, username];
}
