import 'package:equatable/equatable.dart';

abstract class SettingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Mở dialog cập nhật thông tin
class OpenUpdateInfoEvent extends SettingEvent {}

/// Nhấn nút liên kết Google
class LinkGoogleAccountEvent extends SettingEvent {}

/// Nhấn nút chia sẻ QR
class ShowQrEvent extends SettingEvent {}

/// Nhấn logout
class LogoutEvent extends SettingEvent {}