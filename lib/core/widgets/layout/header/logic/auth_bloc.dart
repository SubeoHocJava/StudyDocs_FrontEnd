import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecase/auth_usecases.dart';

// --- Login Bloc ---
abstract class LoginEvent {}
abstract class LoginState {}
class LoginInitial extends LoginState {}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final GoogleLoginUseCase googleLoginUseCase;

  LoginBloc({required this.loginUseCase, required this.googleLoginUseCase}) : super(LoginInitial());
}

// --- Register Bloc ---
abstract class RegisterEvent {}
abstract class RegisterState {}
class RegisterInitial extends RegisterState {}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc({required this.registerUseCase}) : super(RegisterInitial());
}
