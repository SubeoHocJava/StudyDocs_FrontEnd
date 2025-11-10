import "package:flutter_bloc/flutter_bloc.dart";
import '../data/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// ProfileBloc quản lý logic load/update dữ liệu
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    /// Xử lý sự kiện LoadProfile
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await repository.getProfile(event.userId);
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    /// Xử lý sự kiện UpdateProfile
    on<UpdateProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final updatedProfile = await repository.updateProfile(event.data);
        emit(ProfileLoaded(updatedProfile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
