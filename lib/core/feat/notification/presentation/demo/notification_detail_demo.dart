import 'package:flutter/material.dart';
import '../widgets/notification_detail_widget.dart';
import '../../domain/entity/notification_model.dart';

class NotificationDetailDemo extends StatelessWidget {
  const NotificationDetailDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Detail Demo')),
      body: NotificationDetailWidget(
        notification: NotificationModel(
          id: '1',
          title: 'Chi tiết thông báo',
          content: 'Đây là nội dung chi tiết của thông báo mà bạn vừa nhấn vào. Nó chứa đầy đủ các thông tin cần thiết để bạn nắm bắt được sự kiện vừa diễn ra.',
          type: NotificationType.system,
          receivedAt: DateTime.now().subtract(const Duration(minutes: 30)),
          isRead: true,
          avatarUrl: '',
        ),
      ),
    );
  }
}
