abstract interface class NotificationRemoteDataSource {
  Future<dynamic> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> deleteNotification(String id);
}
