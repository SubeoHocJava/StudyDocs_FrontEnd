import 'package:flutter/material.dart';
import '../../domain/entity/notification_model.dart';
import '../../utils/time_utils.dart';

class NotificationDetailWidget extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailWidget({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            TimeUtils.formatTimeAgo(notification.receivedAt),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
          ),
          const Divider(height: 32),
          Text(
            notification.content,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Montserrat',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
