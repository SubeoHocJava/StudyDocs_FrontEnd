import 'package:studydocs/data/model/notification.dart';

abstract interface class NotificationRepository {
  Future<List<Notification>> getNotifications(
    DateTime createAt,
    bool isDeleted,
  );

  Future<void> markAsRead(String notificationId);

  Future<void> markAllAsRead();

  Future<void> softDelete(String notificationId);

  Future<void> hardDelete(String notificationId);
}
