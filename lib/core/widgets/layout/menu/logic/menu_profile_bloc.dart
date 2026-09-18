import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecase/get_menu_profile_usecase.dart';
import '../domain/model/menu_profile.dart';

abstract class MenuProfileEvent {}

class LoadMenuProfile extends MenuProfileEvent {
  final String userId;
  LoadMenuProfile(this.userId);
}

abstract class MenuProfileState {}

class MenuProfileInitial extends MenuProfileState {}
class MenuProfileLoading extends MenuProfileState {}

class MenuProfileLoaded extends MenuProfileState {
  final MenuProfile profile;
  MenuProfileLoaded(this.profile);
}

class MenuProfileError extends MenuProfileState {
  final String message;
  MenuProfileError(this.message);
}

class MenuProfileBloc extends Bloc<MenuProfileEvent, MenuProfileState> {
  final GetMenuProfileUseCase getMenuProfileUseCase;

  MenuProfileBloc(this.getMenuProfileUseCase) : super(MenuProfileInitial()) {
    on<LoadMenuProfile>((event, emit) async {
      emit(MenuProfileLoading());
      try {
        final profile = await getMenuProfileUseCase.execute(event.userId);
        emit(MenuProfileLoaded(profile));
      } catch (e) {
        emit(MenuProfileError(e.toString()));
      }
    });
  }
}
