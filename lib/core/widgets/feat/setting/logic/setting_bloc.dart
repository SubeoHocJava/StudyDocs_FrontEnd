import 'package:flutter_bloc/flutter_bloc.dart';
import 'setting_event.dart';
import 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<OpenUpdateInfoEvent>((event, emit) {
      emit(SettingActionSuccess("open_update_dialog"));
    });

    on<LinkGoogleAccountEvent>((event, emit) {
      emit(SettingActionSuccess("link_google"));
    });

    on<ShowQrEvent>((event, emit) {
      emit(SettingActionSuccess("show_qr"));
    });

    on<LogoutEvent>((event, emit) {
      emit(SettingActionSuccess("logout"));
    });
  }
}