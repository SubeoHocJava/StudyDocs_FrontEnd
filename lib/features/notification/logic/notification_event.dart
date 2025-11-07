import 'package:equatable/equatable.dart';

// Event definitions cho NotificationBloc.
// Mỗi event tương ứng 1 hành động người dùng / side-effect.
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

// Load danh sách notifications (createdAt: tham số cho phân trang/ lọc)
class LoadNotificationEvent extends NotificationEvent {
  final DateTime createdAt;
  final bool isDeleted;

  const LoadNotificationEvent(this.createdAt, this.isDeleted);

  @override
  List<Object?> get props => [createdAt, isDeleted];
}

// Đánh dấu 1 notification đã đọc
class MarkAsReadEvent extends NotificationEvent {
  final String notificationId;

  const MarkAsReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

// Đánh dấu tất cả đã đọc
class MarkAllAsReadEvent extends NotificationEvent {}

enum DeleteType { soft, hard }

// Xoá notification (soft hoặc hard)
class DeleteNotificationEvent extends NotificationEvent {
  final String notificationId;
  final DeleteType type;

  const DeleteNotificationEvent(this.notificationId, this.type);

  // include type trong props để Equatable so sánh đúng
  @override
  List<Object?> get props => [notificationId, type];
}
