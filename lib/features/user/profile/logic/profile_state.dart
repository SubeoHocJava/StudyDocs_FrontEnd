import 'package:studydocs/data/model/user/User.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final User user;
  ProfileLoadedState(this.user);
}

class ProfileErrorState extends ProfileState {
  final String message;
  ProfileErrorState(this.message);
}
