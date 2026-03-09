import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_icons.dart';
import '../../domain/entity/notification_model.dart';
import '../../utils/time_utils.dart';
import '../utils/notification_ui_mapper.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;

  const NotificationItemWidget({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = NotificationUIMapper.getConfig(notification.type);
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isUnread ? AppColors.notificationUnreadLight : AppColors.white,
          border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Notification Icon (Matches Trash)
            Image.asset(
              config['iconAsset'],
              width: 36,
              height: 36,
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                       style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimaryLight,
                        fontFamily: 'Montserrat', 
                        height: 1.4,
                      ),
                      children: [
                         TextSpan(
                          text: notification.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (notification.content.isNotEmpty)
                          TextSpan(
                            text: " " + notification.content,
                            style: TextStyle(
                              fontWeight: FontWeight.normal, 
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    TimeUtils.formatTimeAgo(notification.receivedAt),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: isUnread ? AppColors.primary : AppColors.textSecondaryLight,
                      fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            // 3-dot Menu
            IconButton(
              icon: const Icon(Icons.more_horiz, color: AppColors.textSecondaryLight),
              onPressed: onMoreTap,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
