import 'package:flutter/widgets.dart';
import '../../../../constants/app_colors.dart';
import '../../domain/entity/notification_model.dart';
import 'notification_item.dart';
import 'mark_all_read_widget.dart';

class ActiveNotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final Function(String) onTrashTap;
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
      return const Center(child: Text("Không có thông báo mới"));
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayNotes = notifications.where((n) {
      final d = DateTime(n.receivedAt.year, n.receivedAt.month, n.receivedAt.day);
      return d == today;
    }).toList();

    final earlierNotes = notifications.where((n) {
      final d = DateTime(n.receivedAt.year, n.receivedAt.month, n.receivedAt.day);
      return d.isBefore(today);
    }).toList();

    return ListView(
      children: [
        if (notifications.where((n) => !n.isRead).length >= 2)
          MarkAllReadWidget(onTap: onGlobalMoreTap),
        if (todayNotes.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Hôm nay",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          ...todayNotes.map((n) => NotificationItemWidget(
                notification: n,
                onTap: () => onNotificationTap(n),
                onMoreTap: () => onMoreTap(n),
                onDeleteTap: () => onTrashTap(n.id),
              )),
        ],
        if (earlierNotes.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Text(
              "Trước đó",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
          ...earlierNotes.map((n) => NotificationItemWidget(
                notification: n,
                onTap: () => onNotificationTap(n),
                onMoreTap: () => onMoreTap(n),
                onDeleteTap: () => onTrashTap(n.id),
              )),
        ],
        const SizedBox(height: 80), // Space for bottom nav or FAB if needed
      ],
    );
  }
}