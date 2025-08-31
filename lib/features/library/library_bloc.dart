// import "package:flutter_bloc/flutter_bloc.dart";
//
// import "library_repository.dart";
//
//
// /// ProfileBloc quản lý logic load/update dữ liệu
// class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
//   final LibraryRepository repository;
//
//   LibraryBloc(this.repository) : super(LibraryInitial()) {
//     /// Xử lý sự kiện LoadProfile
//     on<LoadProfile>((event, emit) async {
//       emit(ProfileLoading());
//       try {
//         final profile = await repository.getProfile(event.userId);
//         emit(ProfileLoaded(profile));
//       } catch (e) {
//         emit(ProfileError(e.toString()));
//       }
//     });
//
//     /// Xử lý sự kiện UpdateProfile
//     on<UpdateProfile>((event, emit) async {
//       emit(ProfileLoading());
//       try {
//         final updatedProfile = await repository.updateProfile(event.data);
//         emit(ProfileLoaded(updatedProfile));
//       } catch (e) {
//         emit(ProfileError(e.toString()));
//       }
//     });
//   }
// }
//
// class LibraryInitial {
// }
//
// class LibraryState {
// }
//
// class LibraryEvent {
// }
//
//
