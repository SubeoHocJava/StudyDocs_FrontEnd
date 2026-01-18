import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/model/profile_entity.dart';
import '../domain/repository/profile_repository.dart';
import '../domain/usecase/get_profile_usecase.dart';
import '../domain/usecase/update_avatar_usecase.dart';
import '../domain/usecase/update_profile_usecase.dart';
import '../domain/usecase/verify_email_usecase.dart';
import '../domain/usecase/follow_user_usecase.dart';
import '../domain/usecase/unfollow_user_usecase.dart';

import 'helper.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    final getProfileUseCase = GetProfileUseCase(repository);
    final updateProfileUseCase = UpdateProfileUseCase(repository);
    final updateAvatarUseCase = UpdateAvatarUseCase(repository);
    final verifyEmailUseCase = VerifyEmailUseCase(repository);
    final followUserUseCase = FollowUserUseCase(repository);
    final unfollowUserUseCase = UnfollowUserUseCase(repository);

    // ================= LOAD PROFILE =================
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await getProfileUseCase(event.userId);
        final documents = await repository.getDocumentsByUser(profile.id);

        emit(
          HelperMap.mapProfileToLoaded(
            profile: profile,
            documents: documents,
          ),
        );
      } catch (e) {
        emit(ProfileError('Không thể tải profile: $e'));
      }
    });

    // ================= REFRESH PROFILE =================
    on<RefreshProfile>((event, emit) async {
      try {
        final profile = await getProfileUseCase(event.userId);
        final documents = await repository.getDocumentsByUser(profile.id);

        emit(
          HelperMap.mapProfileToLoaded(
            profile: profile,
            documents: documents,
          ),
        );
      } catch (e) {
        emit(ProfileError('Không thể refresh profile: $e'));
      }
    });

    // ================= UPDATE PROFILE =================
    on<UpdateProfile>((event, emit) async {
      if (state is! ProfileLoaded) return;
      final current = state as ProfileLoaded;

      // bật loading
      emit(current.copyWith(isUpdating: true));

      try {
        final updatedProfile = await updateProfileUseCase(
          ProfileEntity(
            id: current.id,
            username: event.userName,
            fullName: event.fullName,
            email: event.email,
            phoneNumber: event.phoneNumber,
            gender: event.gender ?? current.gender,
            birthDate: event.birthDate ?? current.birthDate,
            address: event.address,
            avatarUrl: current.avatarUrl,
            isVerified: current.isVerified,
            isFollowing: current.isFollowing,
            school: event.school ?? current.school,
            countFollower: 0,
            countFollowing: 0,
          ),
        );

        // ✅ QUAY LẠI PROFILELOADED (KHÔNG EMIT STATE KHÁC)
        emit(
          current.copyWith(
            userName: updatedProfile.username,
            fullName: updatedProfile.fullName,
            email: updatedProfile.email,
            phoneNumber: updatedProfile.phoneNumber,
            gender: updatedProfile.gender,
            birthDate: updatedProfile.birthDate,
            address: updatedProfile.address,
            school: updatedProfile.school,
            isUpdating: false,
          ),
        );
      } catch (e) {
        emit(current.copyWith(isUpdating: false));
        emit(ProfileError('Cập nhật thất bại: $e'));
      }
    });

    // ================= UPDATE AVATAR =================
    on<UpdateAvatar>((event, emit) async {
      if (state is! ProfileLoaded) return;
      final current = state as ProfileLoaded;

      emit(current.copyWith(isUpdating: true));

      try {
        final image = await updateAvatarUseCase(event.file);

        emit(
          current.copyWith(
            avatarUrl: image.path,
            isUpdating: false,
          ),
        );
      } catch (e) {
        emit(current.copyWith(isUpdating: false));
        emit(ProfileError('Cập nhật avatar thất bại: $e'));
      }
    });

    // ================= VERIFY EMAIL =================
    on<VerifyEmail>((event, emit) async {
      if (state is! ProfileLoaded) return;
      final current = state as ProfileLoaded;

      try {
        await verifyEmailUseCase();
        emit(current.copyWith(isVerified: true));
      } catch (e) {
        emit(ProfileError('Xác thực email thất bại: $e'));
      }
    });

    // ================= FOLLOW / UNFOLLOW =================
    on<FollowUser>((event, emit) async {
      if (state is! ProfileLoaded) return;
      final current = state as ProfileLoaded;

      try {
        final newCount = await followUserUseCase(event.userId);
        emit(current.copyWith(isFollowing: true, numFollowMe: newCount));
      } catch (e) {
        emit(ProfileError('Theo dõi thất bại: $e'));
      }
    });

    on<UnfollowUser>((event, emit) async {
      if (state is! ProfileLoaded) return;
      final current = state as ProfileLoaded;

      try {
        final newCount = await unfollowUserUseCase(event.userId);
        emit(current.copyWith(isFollowing: false, numFollowMe: newCount));
      } catch (e) {
        emit(ProfileError('Bỏ theo dõi thất bại: $e'));
      }
    });

    // ================= DOCUMENT: LIKE =================
    on<LikeDocumentRequested>((event, emit) {
      if (state is! ProfileLoaded) return;
      final current = state as ProfileLoaded;

      final updatedDocuments = current.documents.map((doc) {
        if (doc.id != event.documentId) return doc;

        return doc.copyWith(
          likesCount: doc.likesCount + 1,
          isLiked: true,
        );
      }).toList();

      emit(current.copyWith(documents: updatedDocuments));
    });

    // ================= DOCUMENT: DOWNLOAD =================
    on<DownloadDocumentRequested>((event, emit) async {
      // chỉ gọi API, không update state
      // await repository.downloadDocument(event.documentId);
    });
  }
}
