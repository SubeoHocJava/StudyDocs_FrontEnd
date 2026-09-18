import 'package:equatable/equatable.dart';

import '../domain/model/user_profile.dart';

abstract class UpdateInforState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateInitial extends UpdateInforState {}

class UpdateLoading extends UpdateInforState {}

class UpdateInforLoaded extends UpdateInforState {
  final UserProfile profile;
  final List<String> schoolList;

  UpdateInforLoaded(this.profile, this.schoolList);

  @override
  List<Object?> get props => [profile, schoolList];
}

class UpdateSuccess extends UpdateInforState {}

class UpdateError extends UpdateInforState {
  final String message;

  UpdateError(this.message);

  @override
  List<Object?> get props => [message];
}
