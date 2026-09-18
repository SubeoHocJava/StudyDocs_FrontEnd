import 'package:equatable/equatable.dart';

abstract class UpdateEmailState extends Equatable {
  const UpdateEmailState();

  @override
  List<Object> get props => [];
}

class UpdateEmailInitial extends UpdateEmailState {}

class UpdateEmailLoading extends UpdateEmailState {}

class UpdateEmailRequestSuccess extends UpdateEmailState {
  final String email;

  const UpdateEmailRequestSuccess(this.email);

  @override
  List<Object> get props => [email];
}

class UpdateEmailVerifySuccess extends UpdateEmailState {}

class UpdateEmailFailure extends UpdateEmailState {
  final String message;

  const UpdateEmailFailure(this.message);

  @override
  List<Object> get props => [message];
}
