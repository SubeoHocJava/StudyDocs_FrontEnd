import 'package:equatable/equatable.dart';

abstract class SettingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

/// Trả về action để UI xử lý điều hướng/mở dialog
class SettingActionSuccess extends SettingState {
  final String action;

  SettingActionSuccess(this.action);

  @override
  List<Object> get props => [action];
}

class SettingError extends SettingState {
  final String message;

  SettingError(this.message);

  @override
  List<Object> get props => [message];
}