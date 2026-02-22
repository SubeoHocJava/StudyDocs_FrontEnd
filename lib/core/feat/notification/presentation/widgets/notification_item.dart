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
    // debugPrint("Building NotificationItemWidget for ${notification.id}"); // Optional debug
    final config = NotificationUIMapper.getConfig(notification.type);
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isUnread ? AppColors.notificationUnreadLight.withOpacity(0.3) : Colors.transparent, // Highlight unread
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Stack (User Avatar + Notification Type Icon)
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 24,
                  // Use network image in real app, asset for now
                  backgroundImage: AssetImage(notification.avatarUrl), 
                  backgroundColor: AppColors.gray.withOpacity(0.2), 
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2), // Border width
                    child: Image.asset(
                      config['iconAsset'],
                      width: 20,
                      height: 20,
                      // If specific color is needed, apply it. Most icons seem to be full color in design.
                    ),
                  ),
                ),
              ],
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
                        fontFamily: 'Roboto', // Or theme default
                        height: 1.4,
                      ),
                      children: [
                        // Title/Content logic might need adjustments based on exact backend data structure.
                        // Assuming 'title' is "User A and X others liked..."
                         TextSpan(
                          text: notification.title,
                          style: TextStyle(
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        // We could decouple "Action Verb" here if backend sends components separately
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (notification.content.isNotEmpty)
                  Text(
                    notification.content,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondaryLight,
                      fontStyle: FontStyle.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                   const SizedBox(height: 4),
                  Text(
                    TimeUtils.formatTimeAgo(notification.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            
            // 3-dot Menu
            IconButton(
              icon: Image.asset(AppAssets.moreHoriz, width: 20, height: 20, color: AppColors.secondaryBlue,),
              onPressed: onMoreTap,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
