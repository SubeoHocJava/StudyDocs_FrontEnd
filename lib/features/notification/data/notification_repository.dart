import 'package:studydocs/features/notification/models/notification.dart';

import '../api/notification_api.dart';

class NotificationRepository {
  final NotificationApi _notificationApi;

  NotificationRepository(this._notificationApi);

  Future<List<AppNotification>> getNotifications(
    DateTime createAt,
    bool isDeleted,
  ) async {
    try {
      return await _notificationApi.getNotifications(createAt, isDeleted);
    } catch (e) {
      return [];
    }
  }

  //update
  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationApi.markAsRead(notificationId);
    } catch (e) {}
  }

  Future<void> markAllAsRead() async {
    try {
      await _notificationApi.markAllAsRead();
    } catch (e) {}
  }

  //delete
  Future<void> softDelete(String notificationId) async {
    try {
      await _notificationApi.softDelete(notificationId);
    } catch (e) {}
  }

  Future<void> hardDelete(String notificationId) async {
    try {
      await _notificationApi.hardDelete(notificationId);
    } catch (e) {}
  }
}
