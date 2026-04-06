abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {}

class ProfileErrorState extends ProfileState {
  final String message;
  ProfileErrorState(this.message);
}
