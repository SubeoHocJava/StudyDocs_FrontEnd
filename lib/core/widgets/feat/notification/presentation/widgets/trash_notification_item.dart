import 'package:flutter/material.dart';

import '../../../../../constants/app_colors.dart';
import 'package:studydocs/data/model/notification_model.dart';
import '../../utils/time_utils.dart';
import '../utils/notification_ui_mapper.dart';

class TrashNotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final bool isSelected;
  final bool isSelectionMode;
  final Function(bool?) onToggleSelection;
  final VoidCallback onRestore;
  final VoidCallback onDelete;
  final VoidCallback? onLongPress;

  const TrashNotificationItemWidget({
    super.key,
    required this.notification,
    required this.isSelected,
    this.isSelectionMode = false,
    required this.onToggleSelection,
    required this.onRestore,
    required this.onDelete,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final config = NotificationUIMapper.getConfig(notification.type);
    
    return InkWell(
      onTap: isSelectionMode ? () => onToggleSelection(!isSelected) : null,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
          border: Border(bottom: BorderSide(color: AppColors.border.withOpacity(0.5))),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                      if (notification.isDeleted && notification.deletedAt != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE0E0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Đã xóa vào ${notification.deletedAt!.day}/${notification.deletedAt!.month}/${notification.deletedAt!.year}',
                            style: const TextStyle(
                              color: Color(0xFFD32F2F),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Selection Checkbox
            if (isSelectionMode)
              Checkbox(
                value: isSelected,
                onChanged: onToggleSelection,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                activeColor: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
