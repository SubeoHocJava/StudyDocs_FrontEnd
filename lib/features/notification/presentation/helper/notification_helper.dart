import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/domain/entity/notification_section.dart';

// Helper để gom nhóm thông báo theo thời gian (hôm nay / trước đó).
class NotificationHelper {

  // Gom notifications thành 2 list: hôm nay và trước đó
  static List<NotificationSection> buildSections(
      List<NotificationEntity> notifications,
      ) {
    final today = <NotificationEntity>[];
    final ago = <NotificationEntity>[];

    final now = DateTime.now();

    for (final notification in notifications) {
      if (isSameDate(now, notification.receivedAt)) {
        today.add(notification);
      } else {
        ago.add(notification);
      }
    }

    final sections = <NotificationSection>[
      NotificationSection(
        title: 'Hôm nay',
        items: today,
      ),
      NotificationSection(
        title: 'Trước đó',
        items: ago,
      ),
    ];

    return sections.where((section) => section.items.isNotEmpty).toList();
  }

  static bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
