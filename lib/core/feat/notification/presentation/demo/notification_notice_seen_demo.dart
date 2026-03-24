import 'package:flutter/material.dart';
import '../widgets/notification_item.dart';
import '../../domain/entity/notification_model.dart';

class NotificationNoticeSeenDemo extends StatelessWidget {
  const NotificationNoticeSeenDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Seen Demo')),
      body: ListView(
        children: [
          NotificationItemWidget(
            notification: NotificationModel(
              id: '1',
              title: 'Ngọc Thiện',
              content: 'đã bình luận về tài liệu của bạn.',
              type: NotificationType.comment,
              receivedAt: DateTime.now().subtract(const Duration(days: 1)),
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
