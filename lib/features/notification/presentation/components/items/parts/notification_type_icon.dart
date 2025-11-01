import 'package:flutter/material.dart';
import 'package:studydocs/features/notification/data/notification_type.dart';

class NotificationTypeIcon extends StatelessWidget {
  final String type;
  final double size;

  const NotificationTypeIcon({
    super.key,
    required this.type,
    required this.size,
  });

  Widget _buildIcon(String type, double size) {
    var notificationType = NotificationTypeStore.fromType(type);
    final innerSize = (size * 0.5).clamp(16.0, size);
    if (notificationType == null) {
      return CircleAvatar(
        backgroundColor: Colors.red,
        radius: size / 2,
        child: Padding(
          padding: EdgeInsets.all(size * 0.12),
          child: Icon(Icons.info, color: Colors.white, size: innerSize),
        ),
      );
    }
    return CircleAvatar(
      backgroundColor: notificationType.backgroundColor,
      radius: size / 2,
      child: Padding(
        padding: EdgeInsets.all(size * 0.12),
        child: Image.asset(
          notificationType.src,
          width: innerSize,
          height: innerSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildIcon(type, size);
  }
}

