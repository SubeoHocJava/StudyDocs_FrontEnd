import 'package:equatable/equatable.dart';

import 'notification_enum.dart';

// Mỗi event tương ứng 1 hành động người dùng / side-effect.
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

// Load danh sách notifications (receivedAt: tham số cho phân trang/ lọc)
// Load danh sách notifications (cursor: tham số cho phân trang)
class LoadNotificationEvent extends NotificationEvent {
  final dynamic cursor;
  final bool isDeleted;

  const LoadNotificationEvent({this.cursor, required this.isDeleted});

  @override
  List<Object?> get props => [cursor, isDeleted];
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

// Lấy số lượng thông báo chưa đọc
class GetUnreadCountEvent extends NotificationEvent {}

// Xoá notification (soft hoặc hard)
class DeleteNotificationEvent extends NotificationEvent {
  final List<String> notificationIds;
  final DeleteType type;

  const DeleteNotificationEvent(this.notificationIds, this.type);

  @override
  List<Object?> get props => [notificationIds, type];
}

// Khôi phục notifications
class RestoreNotificationEvent extends NotificationEvent {
  final List<String> notificationIds;

  const RestoreNotificationEvent(this.notificationIds);

  @override
  List<Object?> get props => [notificationIds];
}

