import '../entity/notification_model.dart';

abstract interface class NotificationRepository {
  Future<List<NotificationModel>> getNotifications();
  Future<List<NotificationModel>> getTrashNotifications();
  Future<void> markAsRead(String id);
  Future<void> moveToTrash(String id);
  Future<void> restoreFromTrash(String id);
  Future<void> deletePermanently(String id);
  Future<void> moveToTarget(String id, String targetId);
  Future<void> markAllAsRead();
  Future<void> deleteAllPermanently();
  Future<void> restoreAllFromTrash();
}
