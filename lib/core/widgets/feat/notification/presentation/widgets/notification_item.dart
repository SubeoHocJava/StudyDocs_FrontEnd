import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_icons.dart';
import 'package:studydocs/screens/notification/domain/entity/notification_model.dart';
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
                ? const Color(0xFFE6EAFA).withOpacity(0.5)
                : AppColors.white,
            border: Border(
              bottom: BorderSide(
                color: AppColors.border.withOpacity(0.5),
              ),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                          if (notification.content.isNotEmpty)
                            TextSpan(
                              text: " ${notification.content}",
                              style: const TextStyle(
                                color: AppColors.textPrimaryLight,
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
              Stack(
                alignment: Alignment.center,
                children: [
                   GestureDetector(
                    onTap: onMoreTap,
                    child: const Icon(
                      Icons.more_horiz,
                      color: Color(0xFF9E9E9E),
                      size: 20,
                    ),
                  ),
                  if (isUnread)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}