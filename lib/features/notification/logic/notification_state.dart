import 'package:equatable/equatable.dart';
import 'package:studydocs/features/notification/domain/model/notification_entity.dart';

// States cho NotificationBloc — biểu diễn các trạng thái UI khác nhau.
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

// Trạng thái ban đầu (chưa load dữ liệu)
class NotificationInitialState extends NotificationState {}

// Đang tải dữ liệu
class NotificationLoadingState extends NotificationState {}

// Đã tải xong: chứa danh sách notifications
class NotificationLoadedState extends NotificationState {
  final List<NotificationEntity> notifications;

  const NotificationLoadedState(this.notifications);

  @override
  List<Object?> get props => [notifications];

}

// Có lỗi: message để hiển thị hoặc log
class NotificationErrorState extends NotificationState {
  final String message;

  const NotificationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
