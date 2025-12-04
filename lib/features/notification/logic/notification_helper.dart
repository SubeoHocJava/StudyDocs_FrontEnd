import 'package:studydocs/data/model/notification.dart';

// Helper nhỏ để gom nhóm thông báo theo thời gian (hôm nay / trước đó).
// Dùng trong UI để hiển thị section header tương ứng.
class NotificationHelper {
  // key dùng để phân nhóm
  static final String today = "Today";
  static final String ago = "Ago";

  // Gom notifications thành 2 list: hôm nay và trước đó
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

  // So sánh chỉ theo ngày (không so sánh giờ)
  static bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
