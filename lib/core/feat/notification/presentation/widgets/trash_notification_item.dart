import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../domain/entity/notification_model.dart';
import '../../utils/time_utils.dart';
import '../utils/notification_ui_mapper.dart';

class TrashNotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const TrashNotificationItemWidget({
    super.key,
    required this.notification,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final config = NotificationUIMapper.getConfig(notification.type);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
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
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimaryLight,
                      fontFamily: 'Montserrat',
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: notification.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' ${notification.content}'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      TimeUtils.formatTimeAgo(notification.receivedAt),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // "Đã xóa vào" tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE), // Light red/peach
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Đã xóa vào 14/9/2025',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFD32F2F), // Red
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
