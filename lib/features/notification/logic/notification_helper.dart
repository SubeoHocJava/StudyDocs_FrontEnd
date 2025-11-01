import 'package:studydocs/features/notification/models/notification.dart';

class NotificationHelper {
  static final String today = "Today";
  static final String ago = "Ago";

  static Map<String, List<AppNotification>> groupNotificationsByTime(
    List<AppNotification> notifications,
  ) {
    final todayNotifications = <AppNotification>[];
    final agoNotification = <AppNotification>[];
    final now = DateTime.now();
    for (final notification in notifications) {
      if (isSameDate(now, notification.createdAt)) {
        todayNotifications.add(notification);
      } else {
        agoNotification.add(notification);
      }
    }
    return {today: todayNotifications, ago: agoNotification};
  }

  static bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
