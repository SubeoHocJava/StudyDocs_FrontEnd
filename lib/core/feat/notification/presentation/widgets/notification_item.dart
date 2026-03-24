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
  final VoidCallback? onDeleteTap;

  const NotificationItemWidget({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onMoreTap,
    this.onDeleteTap,
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
          color: isUnread
              ? AppColors.notificationUnreadLight
              : AppColors.white,
          border: Border(
            bottom: BorderSide(
              color: AppColors.border.withValues(alpha: 0.5),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [ 
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isUnread
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.border.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                config['iconAsset'],
                width: 20,
                height: 20,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: notification.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        if (notification.content.isNotEmpty)
                          TextSpan(
                            text: " ${notification.content}",
                            style: TextStyle(
                              color: AppColors.textPrimaryLight,
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
                      color: isUnread
                          ? AppColors.primary
                          : AppColors.textSecondaryLight,
                      fontWeight:
                          isUnread ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            // More button
            IconButton(
              icon: const Icon(
                Icons.more_horiz,
                color: AppColors.textSecondaryLight,
              ),
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