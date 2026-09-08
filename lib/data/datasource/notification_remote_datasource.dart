abstract interface class NotificationRemoteDataSource {
  Future<dynamic> getNotifications();
  Future<dynamic> getTrashNotifications();
  Future<void> markAsRead(String id);
  Future<void> deleteNotification(String id);
  Future<void> restoreNotification(String id);
  Future<void> hardDeleteNotification(String id);
}
