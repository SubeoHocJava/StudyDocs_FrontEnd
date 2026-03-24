import 'package:flutter/material.dart';
import '../widgets/notification_item.dart';
import '../../domain/entity/notification_model.dart';

class NotificationNoticeDemo extends StatelessWidget {
  const NotificationNoticeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '❖ Notice',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            NotificationItemWidget(
              notification: NotificationModel(
                id: '1',
                title: 'Ngọc Thiện',
                content: 'và 15 người khác đã thích tài liệu của bạn: Tài liệu hướng dẫn sử dụng...',
                type: NotificationType.like,
                receivedAt: DateTime.now().subtract(const Duration(minutes: 2)),
                isRead: false,
                avatarUrl: '',
              ),
              onTap: () {},
              onMoreTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
