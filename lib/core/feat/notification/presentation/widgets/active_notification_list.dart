import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../domain/entity/notification_model.dart';
import 'notification_item.dart';

class ActiveNotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final VoidCallback onTrashTap;
  final Function(NotificationModel) onNotificationTap;
  final Function(NotificationModel) onMoreTap;

  const ActiveNotificationList({
    Key? key,
    required this.notifications,
    required this.onTrashTap,
    required this.onNotificationTap,
    required this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) return const Center(child: Text("Không có thông báo mới"));
    return ListView.builder(
      itemCount: notifications.length + 1,
      itemBuilder: (ctx, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hôm nay", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimaryLight)),
                InkWell(
                  onTap: onTrashTap,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.delete_outline, color: AppColors.textSecondaryLight, size: 24),
                  ),
                ),
              ],
            ),
          );
        }
        final note = notifications[index - 1];
        return NotificationItemWidget(
          notification: note,
          onTap: () => onNotificationTap(note),
          onMoreTap: () => onMoreTap(note),
        );
      },
    );
  }
}
