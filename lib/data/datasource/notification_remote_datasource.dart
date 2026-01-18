import 'package:studydocs/data/model/cursor_pagination_result.dart';
import 'package:studydocs/data/model/notification.dart';
import 'package:studydocs/data/model/notification_metadata.dart';

abstract interface class NotificationDataSource {
  Future<CursorPaginationResult<Notification>> getNotifications(
    dynamic cursor,
    bool isDeleted,
  );

  Future<int> getUnreadCount();

  Future<void> markAsRead(String notificationId);

  Future<void> softDelete(List<String> notificationIds);

  Future<void> hardDelete(List<String> notificationIds);

  Future<void> markAllAsRead();

  Future<void> restore(List<String> notificationIds);

  Future<List<NotificationMetadata>> getMetadata();

  Future<void> registerFcmToken(String token);
}