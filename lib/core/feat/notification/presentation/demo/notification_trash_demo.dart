import 'package:flutter/material.dart';
import '../widgets/trash_notification_item.dart';
import '../../domain/entity/notification_model.dart';

class NotificationTrashDemo extends StatefulWidget {
  const NotificationTrashDemo({super.key});

  @override
  State<NotificationTrashDemo> createState() => _NotificationTrashDemoState();
}

class _NotificationTrashDemoState extends State<NotificationTrashDemo> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    final mockTrashNotification = NotificationModel(
      id: '4',
      title: 'Ngọc Thiện',
      content: 'và 15 người khác đã thích tài liệu của bạn: Tài liệu hướng dẫn sử dụng...',
      avatarUrl: 'https://i.pravatar.cc/150?u=4',
      type: NotificationType.like,
      receivedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      isRead: true,
      deletedAt: DateTime(2025, 9, 14), // Matches image
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Demo: Trash Notification'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Tính năng: Thông báo trong thùng rác',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TrashNotificationItemWidget(
            notification: mockTrashNotification,
            isSelected: _isSelected,
            onToggleSelection: (val) {
              setState(() {
                _isSelected = val ?? false;
              });
            },
            onRestore: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restored notification')),
              );
            },
            onDelete: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Deleted permanently')),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('Ghi chú: Thông báo trong thùng rác có thêm nút Khôi phục và Xóa vĩnh viễn ở bên phải.'),
          ),
        ],
      ),
    );
  }
}
