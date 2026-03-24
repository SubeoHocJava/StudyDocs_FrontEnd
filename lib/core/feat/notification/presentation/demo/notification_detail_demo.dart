import 'package:flutter/material.dart';
import '../widgets/notification_detail_widget.dart';
import '../../domain/entity/notification_model.dart';

class NotificationDetailDemo extends StatelessWidget {
  const NotificationDetailDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '❖ Chi tiết thông báo',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Spacer(),
            NotificationDetailWidget(
              notification: NotificationModel(
                id: '1',
                title: 'Tuấn Dũng',
                content: 'đã bình luận về tài liệu của bạn: Cho mình xin thêm chương mới về phần socket của môn này được không bạn.',
                type: NotificationType.comment,
                receivedAt: DateTime.now(),
                isRead: true,
                avatarUrl: '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
