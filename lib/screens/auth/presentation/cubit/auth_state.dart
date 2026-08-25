import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final String? displayName;
  final String? username;
  final String? avatarUrl;

  const AuthAuthenticated({this.displayName, this.username, this.avatarUrl});

  @override
  List<Object?> get props => [displayName, username, avatarUrl];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthRegisterSuccess extends AuthState {
  const AuthRegisterSuccess();
}

class AuthGooglePending extends AuthState {
  const AuthGooglePending();
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
