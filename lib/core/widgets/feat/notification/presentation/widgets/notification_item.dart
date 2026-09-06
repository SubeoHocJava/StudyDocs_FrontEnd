import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_icons.dart';
import 'package:studydocs/data/model/notification_model.dart';
import '../../utils/time_utils.dart';
import '../utils/notification_ui_mapper.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;
  final VoidCallback? onDeleteTap;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMoreTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final config = NotificationUIMapper.getConfig(notification.type);
    final isUnread = !notification.isRead;

    return Slidable(
      key: ValueKey(notification.id),
      enabled: onDeleteTap != null,
      endActionPane: onDeleteTap != null
          ? ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              children: [
                CustomSlidableAction(
                  onPressed: (_) => onDeleteTap?.call(),
                  backgroundColor: const Color(0xFFFFDDE1), // Light pink/red
                  foregroundColor: const Color(0xFFD32F2F), // Dark red
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.bin, 
                        width: 28, 
                        height: 28, 
                        color: const Color(0xFFD32F2F),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Xóa',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFD32F2F),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : null,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isUnread
                ? AppColors.primary.withValues(alpha: 0.1) // Làm nền xanh nhạt rõ hơn
                : AppColors.white,
            border: Border(
              bottom: BorderSide(
                color: AppColors.border.withValues(alpha: 0.5),
              ),
              left: isUnread
                  ? const BorderSide(color: AppColors.primary, width: 4)
                  : const BorderSide(color: Colors.transparent, width: 4),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                config['iconAsset'],
                width: 38,
                height: 38,
              ),
              const SizedBox(width: 14),
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
                              fontWeight: isUnread ? FontWeight.w800 : FontWeight.bold,
                              color: isUnread ? Colors.black87 : AppColors.textPrimaryLight,
                            ),
                          ),
                          if (notification.content.isNotEmpty)
                            TextSpan(
                              text: " ${notification.content}",
                              style: TextStyle(
                                fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                                color: isUnread ? Colors.black87 : AppColors.textPrimaryLight,
                              ),
                            ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      TimeUtils.formatTimeAgo(notification.receivedAt),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: isUnread
                            ? AppColors.primary
                            : AppColors.textSecondaryLight,
                        fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   GestureDetector(
                    onTap: onMoreTap,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.more_horiz,
                        color: Color(0xFF757575), // Đậm hơn một chút
                        size: 24, // To hơn để dễ bấm
                      ),
                    ),
                  ),
                  if (isUnread) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}