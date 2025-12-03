import 'package:flutter/material.dart';
import 'package:studydocs/features/notification/logic/notification_helper.dart';
import 'package:studydocs/features/notification/presentation/component/items/notification_items_container.dart';
import 'package:studydocs/features/notification/presentation/component/items/notification_section_header.dart';
import 'component/shared/notification_page_layout.dart';

class NotificationScreen extends StatelessWidget {
  final String userId;

  const NotificationScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return NotificationPageLayout(
      isDeleted: false, // Load active notifications
      emptyMessage: "Chưa có dữ liệu",
      childBuilder: (notifications) {
        final mapNotification = NotificationHelper.groupNotificationsByTime(
          notifications,
        );
        final todayNotifications = mapNotification[NotificationHelper.today] ?? [];
        final agoNotifications = mapNotification[NotificationHelper.ago] ?? [];

        return ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            if (index == 0 && todayNotifications.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NotificationSectionHeader(time: "Hôm nay"),
                  NotificationItemsContainer(
                    notifications: todayNotifications,
                  ),
                ],
              );
            } else if (index == 1 && agoNotifications.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NotificationSectionHeader(time: "Trước đó"),
                  NotificationItemsContainer(
                    notifications: agoNotifications,
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
