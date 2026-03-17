import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/feat/notification/domain/entity/notification_model.dart';
import 'package:studydocs/core/feat/notification/presentation/utils/notification_ui_mapper.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onNotificationTap;
  final VoidCallback onMoreTap;
  final VoidCallback onDeleteTap;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onNotificationTap,
    required this.onMoreTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final uiConfig = NotificationUIMapper.getConfig(notification.type);
    
    return Slidable(
      key: ValueKey(notification.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => onDeleteTap(),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Xóa',
          ),
        ],
      ),
      child: ListTile(
        onTap: onNotificationTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: notification.isRead ? Colors.transparent : AppColors.primary.withOpacity(0.05),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(notification.avatarUrl),
              backgroundColor: Colors.grey[200],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  uiConfig['iconAsset'],
                  width: 14,
                  height: 14,
                  color: uiConfig['iconColor'],
                ),
              ),
            ),
          ],
        ),
        title: RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: const TextStyle(color: Colors.black87, fontSize: 14),
            children: [
              TextSpan(
                text: notification.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' '),
              TextSpan(text: uiConfig['actionVerb']),
              const TextSpan(text: ' '),
              TextSpan(text: notification.content),
            ],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            _formatTime(notification.receivedAt),
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: onMoreTap,
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}
