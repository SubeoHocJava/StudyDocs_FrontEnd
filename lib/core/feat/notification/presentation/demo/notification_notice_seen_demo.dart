import 'package:flutter/material.dart';
import '../widgets/notification_item.dart';
import '../../domain/entity/notification_model.dart';

class NotificationNoticeSeenDemo extends StatelessWidget {
  const NotificationNoticeSeenDemo({super.key});

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
                '❖ Notice seen',
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
                title: 'Lâm Bảo Duy',
                content: 'và 4 người khác đã thích tài liệu của bạn: Cách tán đổ 10 em gái k...',
                type: NotificationType.like,
                receivedAt: DateTime.now().subtract(const Duration(hours: 5)),
                isRead: true,
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
