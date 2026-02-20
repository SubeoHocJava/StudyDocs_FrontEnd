// setting_state.dart
abstract class SettingState {}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingQRDataLoaded extends SettingState {
  final String qrData;
  SettingQRDataLoaded(this.qrData);
}

class SettingError extends SettingState {
  final String message;
  SettingError(this.message);
}