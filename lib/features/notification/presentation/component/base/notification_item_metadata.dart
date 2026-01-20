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
            color: Theme.of(context).hintColor,
          ),
        ),
        if (notification.deletedAt != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Đã xóa vào ${notification.formattedDeletedTime()}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
