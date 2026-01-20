import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/error/error_mapper.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';
import 'package:studydocs/data/model/auth/response/user_me_response.dart';
import 'package:studydocs/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:studydocs/services/token_storage_service.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/params/login_params.dart';

/// -----------------------------
/// EVENT
/// -----------------------------

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;

  const LoginSubmitted({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class GoogleLoginSubmitted extends LoginEvent {
  final String? idToken;
  const GoogleLoginSubmitted({this.idToken});

  @override
  List<Object?> get props => [idToken];
}

/// -----------------------------
/// STATE
/// -----------------------------

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Đăng nhập thành công, chứa thông tin User đầy đủ và Token.
class LoginSuccess extends LoginState {
  final UserMeResponse user;
  final String accessToken;

  const LoginSuccess({required this.user, required this.accessToken});

  @override
  List<Object?> get props => [user, accessToken];
}

class LoginFailure extends LoginState {
  final String message;
  final int? errorCode;

  const LoginFailure(this.message, {this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

/// -----------------------------
/// BLOC
/// -----------------------------

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final GoogleLoginUseCase googleLoginUseCase;

  LoginBloc({required this.loginUseCase, required this.googleLoginUseCase})
    : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<GoogleLoginSubmitted>(_onGoogleLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    try {
      final user = await loginUseCase(
        params: LoginParams(username: event.username, password: event.password),
      );
      
      final token = await TokenStorageService().getAccessToken() ?? '';
      
      emit(LoginSuccess(user: user, accessToken: token));
    } catch (e) {
      if (e is ApiException) {
        final errorCode = int.tryParse(e.code ?? '');
        final mappedMessage = ErrorMapper.map(errorCode, defaultMessage: e.message);
        emit(LoginFailure(mappedMessage, errorCode: errorCode));
      } else {
        emit(LoginFailure(e.toString()));
      }
    }
  }

  Future<void> _onGoogleLoginSubmitted(
    GoogleLoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    try {
      final user = await googleLoginUseCase(idToken: event.idToken);
      final token = await TokenStorageService().getAccessToken() ?? '';
      emit(LoginSuccess(user: user, accessToken: token));
    } catch (e) {
      if (e is ApiException) {
        final errorCode = int.tryParse(e.code ?? '');
        final mappedMessage = ErrorMapper.map(errorCode, defaultMessage: e.message);
        emit(LoginFailure(mappedMessage, errorCode: errorCode));
      } else {
        emit(LoginFailure(e.toString()));
      }
    }
  }
}
