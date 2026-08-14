import 'package:flutter/material.dart';
import '../../../../../constants/app_icons.dart';
import 'package:studydocs/screens/notification/domain/entity/notification_model.dart';
import '../../utils/time_utils.dart';
import '../utils/notification_ui_mapper.dart';

class NotificationDetailWidget extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailWidget({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final config = NotificationUIMapper.getConfig(notification.type);
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          // Icon Circle (Asset already contains circle)
          Image.asset(
            config['iconAsset'],
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 20),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1A237E),
                      fontFamily: 'Montserrat',
                      height: 1.5,
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
                if (notification.isDeleted && notification.deletedAt != null) ...[
                  const SizedBox(height: 8),
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
                const SizedBox(height: 8),
                Text(
                  TimeUtils.formatTimeAgo(notification.receivedAt),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, indent: 24, endIndent: 24),
          const SizedBox(height: 12),
          // Actions
          ListTile(
            leading: Image.asset(AppAssets.notiMarkAsRead, width: 24, height: 24),
            title: const Text(
              'Đánh dấu là đã đọc',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
                fontFamily: 'Montserrat',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Image.asset(AppAssets.bin, width: 24, height: 24, color: const Color(0xFF1A237E)),
            title: const Text(
              'Xóa thông báo này',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
                fontFamily: 'Montserrat',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
