import 'package:flutter/material.dart';
import '../../domain/entity/notification_model.dart';
import 'notification_item.dart';

class ActiveNotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final VoidCallback onTrashTap;
  final Function(NotificationModel) onNotificationTap;
  final Function(NotificationModel) onMoreTap;
  final VoidCallback onGlobalMoreTap;

  const ActiveNotificationList({
    super.key,
    required this.notifications,
    required this.onTrashTap,
    required this.onNotificationTap,
    required this.onMoreTap,
    required this.onGlobalMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const Center(child: Text('Không có thông báo nào'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mới nhất',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: onGlobalMoreTap,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (ctx, idx) => Divider(height: 1, color: Colors.grey[200]),
            itemBuilder: (ctx, idx) {
              return NotificationItemWidget(
                notification: notifications[idx],
                onNotificationTap: () => onNotificationTap(notifications[idx]),
                onMoreTap: () => onMoreTap(notifications[idx]),
                onDeleteTap: onTrashTap,
              );
            },
          ),
        ),
      ],
    );
  }
}
