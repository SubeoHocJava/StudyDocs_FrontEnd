import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../domain/entity/notification_model.dart';
import '../utils/notification_ui_mapper.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final config = NotificationUIMapper.getConfig(notification.type);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.transparent : const Color(0xFFF5F6FF),
          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon instead of Avatar
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: notification.isRead ? Colors.transparent : const Color(0xFFE8EAF6),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                config['iconAsset'],
                width: 24,
                height: 24,
                color: const Color(0xFF1A237E),
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
                        color: Colors.black,
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
                  Text(
                    _formatTime(notification.receivedAt),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // More Button
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Color(0xFF1A237E)),
              onPressed: onMoreTap,
            ),
          ],
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
