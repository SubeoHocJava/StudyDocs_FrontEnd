import 'package:flutter/material.dart';

class NotificationItemText extends StatelessWidget {
  final String content;
  final double fontSize;
  final bool isRead;

  const NotificationItemText({
    super.key,
    required this.content,
    required this.fontSize,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyMedium;
    final textStyle = base?.copyWith(
          fontSize: fontSize,
          fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
          color: isRead ? base.color?.withOpacity(0.8) : base.color,
        ) ?? TextStyle(
          fontSize: fontSize,
          fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
        );

    return Text(
      content,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
  }
}
