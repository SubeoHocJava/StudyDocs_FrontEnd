import 'package:flutter/material.dart';
import 'package:studydocs/data/model/notification.dart';
import 'package:studydocs/features/notification/presentation/components/items/parts/notification_type_icon.dart';

/// Widget hiển thị nội dung chi tiết của notification trong modal
/// - Icon loại notification (lớn hơn trong list)
/// - Nội dung đầy đủ (không giới hạn số dòng)
/// - Divider phân cách với phần actions
/// Kích thước (icon, font) được điều chỉnh theo màn hình
class NotificationModalContent extends StatelessWidget {
  final AppNotification notification;
  final double iconSize;
  final double fontSize;

  const NotificationModalContent({
    super.key,
    required this.notification,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: NotificationTypeIcon(
              type: notification.type,
              size: iconSize,
            ),
          ),
        ),
        Text(
          notification.content,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(height: 1),
        ),
      ],
    );
  }
}

