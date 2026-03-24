import 'package:flutter/material.dart';
import '../widgets/notification_item.dart';
import '../../domain/entity/notification_model.dart';

class NotificationNoticeDemo extends StatelessWidget {
  const NotificationNoticeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Notice Demo')),
      body: ListView(
        children: [
          NotificationItemWidget(
            notification: NotificationModel(
              id: '1',
              title: 'Ngọc Thiện',
              content: 'và 15 người khác đã thích tài liệu của bạn: "Giải thuật 1"',
              type: NotificationType.like,
              receivedAt: DateTime.now().subtract(const Duration(minutes: 2)),
              isRead: false,
              avatarUrl: '', // Not used anymore
            ),
            onNotificationTap: () {},
            onMoreTap: () {},
            onDeleteTap: () {},
          ),
          NotificationItemWidget(
            notification: NotificationModel(
              id: '2',
              title: 'Hệ thống',
              content: 'đã cập nhật tài liệu mới trong thư mục của bạn.',
              type: NotificationType.system,
              receivedAt: DateTime.now().subtract(const Duration(hours: 1)),
              isRead: true,
              avatarUrl: '',
            ),
            onNotificationTap: () {},
            onMoreTap: () {},
            onDeleteTap: () {},
          ),
        ],
      ),
    );
  }
}
