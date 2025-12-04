import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    // -------------------------------
    // LOAD PROFILE
    // -------------------------------
    on<LoadProfile>(_onLoadProfile);

    // -------------------------------
    // UPDATE PROFILE
    // -------------------------------
    on<UpdateProfile>(_onUpdateProfile);
  }

  // ========================================
  // LOAD PROFILE HANDLER
  // ========================================
  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getProfile(event.userId);

      emit(ProfileLoaded(
        userName: profile.userName,
        fullName: profile.fullName,
        email: profile.email,
        phoneNumber: profile.phoneNumber,
        gender: profile.gender,
        birthDate: profile.birthDate,
        address: profile.address, school: '',
      ));
    } catch (e) {
      emit(ProfileError("Không thể tải thông tin: $e"));
    }
  }

  // ========================================
  // UPDATE PROFILE HANDLER
  // ========================================
  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final data = {
        "userName": event.userName,
        "fullName": event.fullName,
        "school":'Đại học nông lâm',
        "email": event.email,
        "phoneNumber": event.phoneNumber,
        "gender": event.gender,
        "birthDate": event.birthDate?.toIso8601String(),
        "address": event.address,
      };

      final updatedProfile = await repository.updateProfile(data);

      emit(ProfileLoaded(
        userName: updatedProfile.userName,
        fullName: updatedProfile.fullName,
        email: updatedProfile.email,
        phoneNumber: updatedProfile.phoneNumber,
        gender: updatedProfile.gender,
        birthDate: updatedProfile.birthDate,
        address: updatedProfile.address, school: '',
      ));
    } catch (e) {
      emit(ProfileError("Cập nhật thất bại: $e"));
    }
  }
}
