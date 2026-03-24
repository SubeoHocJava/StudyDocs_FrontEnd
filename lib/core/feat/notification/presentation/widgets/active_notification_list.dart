import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../domain/entity/notification_model.dart';
import 'notification_item.dart';

class ActiveNotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final VoidCallback onTrashTap;
  final Function(NotificationModel) onNotificationTap;
  final Function(NotificationModel) onMoreTap;
  final VoidCallback onGlobalMoreTap;

  const ActiveNotificationList({
    Key? key,
    required this.notifications,
    required this.onTrashTap,
    required this.onNotificationTap,
    required this.onMoreTap,
    required this.onGlobalMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const Center(child: Text("Không có thông báo mới"));
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayNotes = notifications.where((n) {
      final noteDate = DateTime(n.receivedAt.year, n.receivedAt.month, n.receivedAt.day);
      return noteDate == today;
    }).toList();

    final earlierNotes = notifications.where((n) {
      final noteDate = DateTime(n.receivedAt.year, n.receivedAt.month, n.receivedAt.day);
      return noteDate.isBefore(today);
    }).toList();

    return ListView(
      children: [
        // ===== TODAY =====
        if (todayNotes.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Hôm nay",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: AppColors.primary),
                  onPressed: onGlobalMoreTap,
                ),
              ],
            ),
          ),
          ...todayNotes.map((note) => NotificationItemWidget(
                notification: note,
                onTap: () => onNotificationTap(note), // giữ style ver2
                onMoreTap: () => onMoreTap(note),
                onDeleteTap: onTrashTap, // 🔥 merge từ feature
              )),
        ],

        // ===== EARLIER =====
        if (earlierNotes.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: const Text(
              "Trước đó",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
          ...earlierNotes.map((note) => NotificationItemWidget(
                notification: note,
                onTap: () => onNotificationTap(note),
                onMoreTap: () => onMoreTap(note),
                onDeleteTap: onTrashTap, 
              )),
        ],
      ],
    );
  }
}