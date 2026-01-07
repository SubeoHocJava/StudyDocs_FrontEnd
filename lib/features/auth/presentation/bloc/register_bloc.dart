import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/register_usecase.dart';
import '../../domain/params/register_params.dart';


/// -----------------------------
/// EVENT
/// -----------------------------
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String username;
  final String? email;
  final String password;

  const RegisterSubmitted({
    required this.username,
    this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}

/// -----------------------------
/// STATE
/// -----------------------------
abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final String message;

  const RegisterSuccess({this.message = 'Tạo tài khoản thành công, vui lòng đăng nhập'});

  @override
  List<Object?> get props => [message];
}

class RegisterFailure extends RegisterState {
  final String message;

  const RegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// -----------------------------
/// BLOC
/// -----------------------------
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc({required this.registerUseCase}) : super(const RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoading());
    try {
      await registerUseCase(
        params: RegisterParams(
          username: event.username,
          email: event.email,
          password: event.password,
        ),
      );
      emit(const RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
