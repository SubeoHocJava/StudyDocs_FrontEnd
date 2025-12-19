import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/profile/logic/helper.dart';
import '../../../data/model/user.dart';

import '../domain/model/profile_entity.dart';
import '../domain/repository/profile_repository.dart';
import '../domain/usecase/get_profile_usecase.dart';
import '../domain/usecase/update_avatar_usecase.dart';
import '../domain/usecase/update_profile_usecase.dart';
import '../domain/usecase/verify_email_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    // ================= USE CASES =================
    final getProfileUseCase = GetProfileUseCase(repository);
    final updateProfileUseCase = UpdateProfileUseCase(repository);
    final updateAvatarUseCase = UpdateAvatarUseCase(repository);
    final verifyEmailUseCase = VerifyEmailUseCase(repository);

    // ================= LOAD PROFILE =================
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await getProfileUseCase(event.userId);
        emit(HelperMap.mapProfileToLoaded(profile));
      } catch (e) {
        emit(ProfileError("Không thể tải profile: $e"));
      }
    });

    // ================= REFRESH PROFILE =================
    on<RefreshProfile>((event, emit) async {
      try {
        final profile = await getProfileUseCase(event.userId);
        emit(HelperMap.mapProfileToLoaded(profile));
      } catch (e) {
        emit(ProfileError("Không thể refresh: $e"));
      }
    });

    // ================= UPDATE PROFILE =================
    on<UpdateProfile>((event, emit) async {
      if (state is! ProfileLoaded) return;
      final current = state as ProfileLoaded;

      emit(current.copyWith(isUpdating: true));

      try {
        final updatedProfile = await updateProfileUseCase({
          "userName": event.userName,
          "fullName": event.fullName,
          "school": current.school,
          "email": event.email,
          "phoneNumber": event.phoneNumber,
          "gender": event.gender,
          "birthDate": event.birthDate?.toIso8601String(),
          "address": event.address,
        });

        emit(
          current.copyWith(
            fullName: updatedProfile.fullName,
            email: updatedProfile.email,
            phoneNumber: updatedProfile.phoneNumber,
            gender: updatedProfile.gender,
            birthDate: updatedProfile.birthDate,
            address: updatedProfile.address,
            isUpdating: false,
          ),
        );

        emit(const ProfileUpdateSuccess());
      } catch (e) {
        emit(current.copyWith(isUpdating: false));
        emit(ProfileUpdateFailure("Cập nhật thất bại: $e"));
      }
    });

    // ================= UPDATE AVATAR =================
    on<UpdateAvatar>((event, emit) async {
      if (state is! ProfileLoaded) return;
      final current = state as ProfileLoaded;

      emit(current.copyWith(isUpdating: true));

      try {
        final avatarUrl = await updateAvatarUseCase(event.imagePath);
        emit(current.copyWith(avatarUrl: avatarUrl, isUpdating: false));
        emit(const ProfileUpdateSuccess(message: "Cập nhật avatar thành công"));
      } catch (e) {
        emit(current.copyWith(isUpdating: false));
        emit(ProfileUpdateFailure("Cập nhật avatar thất bại: $e"));
      }
    });

    // ================= VERIFY EMAIL =================
    on<VerifyEmail>((event, emit) async {
      if (state is! ProfileLoaded) return;
      final current = state as ProfileLoaded;

      try {
        await verifyEmailUseCase();
        emit(current.copyWith(isVerified: true));
        emit(const ProfileUpdateSuccess(message: "Email đã được xác thực"));
      } catch (e) {
        emit(ProfileUpdateFailure("Xác thực email thất bại: $e"));
      }
    });

    // ================= CLEAR ACTION =================
    on<ClearProfileActionState>((event, emit) {
      if (state is ProfileLoaded) {
        emit(state);
      }
    });
  }



}
