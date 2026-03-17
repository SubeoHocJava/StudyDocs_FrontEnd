import 'package:flutter/material.dart';
import '../widgets/notification_options_bottom_sheet.dart';
import '../../domain/entity/notification_model.dart';

class NotificationDetailDemo extends StatelessWidget {
  const NotificationDetailDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final mockNotification = NotificationModel(
      id: '3',
      title: 'Tuấn Dũng',
      content: 'đã bình luận về tài liệu của bạn: Cho mình xin thêm chương mới về phần socket của môn này được không bạn.',
      avatarUrl: 'https://i.pravatar.cc/150?u=3',
      type: NotificationType.comment,
      receivedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      isRead: false,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Demo: Notification Detail'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              builder: (ctx) => NotificationOptionsBottomSheet(
                notification: mockNotification,
                onMarkAsRead: () {},
                onDelete: () {},
              ),
            );
          },
          child: const Text('Show Notification Options'),
        ),
      ),
    );
  }
}
