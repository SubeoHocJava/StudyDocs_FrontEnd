import 'package:flutter/material.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';

class NotificationItemMetadata extends StatelessWidget {
  final NotificationEntity notification;
  final double fontSize;

  const NotificationItemMetadata({
    super.key,
    required this.notification,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.formattedCreatedTime(),
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.grey, // Preserving color from original code
          ),
        ),
        if (notification.deletedAt != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE5E5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Đã xóa vào ${notification.formatDeletedTime()}",
                style: TextStyle(
                  color: const Color(0xFFFF3B30),
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
