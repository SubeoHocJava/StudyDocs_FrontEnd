import 'package:flutter/material.dart';
import 'package:studydocs/features/notification/presentation/component/items/notification_items_container.dart';
import 'component/shared/notification_page_layout.dart';

class NotificationTrashScreen extends StatelessWidget {
  final String userId;

  const NotificationTrashScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return NotificationPageLayout(
      isDeleted: true, // Load deleted notifications
      emptyMessage: "Chưa có thông báo nào bị xóa",
      childBuilder: (notifications) {
        return ListView(
          children: [
            NotificationItemsContainer(notifications: notifications),
          ],
        );
      },
    );
  }
}
