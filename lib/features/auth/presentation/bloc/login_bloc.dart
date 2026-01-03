import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/auth/domain/usecases/google_login_usecase.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/params/login_params.dart';

/// -----------------------------
/// EVENT
/// -----------------------------

/// Các sự kiện (event) mà màn hình đăng nhập có thể phát ra.
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Khi người dùng bấm nút "Đăng nhập".
class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;

  const LoginSubmitted({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

/// -----------------------------
/// STATE
/// -----------------------------

/// Các trạng thái (state) của quá trình đăng nhập.
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu: chưa làm gì.
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Đang gửi request đăng nhập (hiển thị loading).
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Đăng nhập thành công.
/// Bạn có thể thay [token] bằng model User tuỳ nhu cầu sau này.
class LoginSuccess extends LoginState {
  final String token;

  const LoginSuccess(this.token);

  @override
  List<Object?> get props => [token];
}

/// Đăng nhập thất bại (lỗi server, sai mật khẩu, v.v.).
class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// -----------------------------
/// BLOC
/// -----------------------------

/// BLoC chịu trách nhiệm:
/// - Nhận [LoginSubmitted] từ UI
/// - Gọi [LoginUseCase] (tầng domain / repository) để đăng nhập
/// - Phát ra các state: [LoginLoading], [LoginSuccess], [LoginFailure]
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final GoogleLoginUseCase googleLoginUseCase;

  LoginBloc({required this.loginUseCase, required this.googleLoginUseCase})
    : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<GoogleLoginSubmitted>(_onGoogleLoginSubmitted);
  }

  /// Hàm xử lý khi nhận event [LoginSubmitted].
  /// Tại đây ta chỉ:
  /// - Phát state loading
  /// - Gọi usecase
  /// - Bắt lỗi & phát state tương ứng
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    try {
      final token = await loginUseCase(
        params: LoginParams(username: event.username, password: event.password),
      );
      emit(LoginSuccess(token));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onGoogleLoginSubmitted(
    GoogleLoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    try {
      final token = await googleLoginUseCase();
      emit(LoginSuccess(token));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}

//
class GoogleLoginSubmitted extends LoginEvent {
  const GoogleLoginSubmitted();
}
