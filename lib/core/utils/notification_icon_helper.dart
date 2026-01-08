import 'package:flutter/material.dart';

class NotificationIconHelper {
  static Widget getIcon(String type, {double size = 40, double? iconSize}) {
    IconData iconData;
    Color color;
    double actualIconSize = iconSize ?? (size * 0.6);

    switch (type.toUpperCase()) {
      case 'LIKE':
        iconData = Icons.thumb_up_alt_rounded;
        color = Colors.blue;
        break;
      case 'DOWNLOAD':
        iconData = Icons.download_rounded;
        color = Colors.green;
        break;
      case 'COMMENT':
        iconData = Icons.comment_rounded;
        color = Colors.orange;
        break;
      case 'SYSTEM':
        iconData = Icons.info_outline_rounded;
        color = Colors.purple;
        break;
      case 'NEW_POST':
        iconData = Icons.article_rounded;
        color = Colors.teal;
        break;
      default:
        iconData = Icons.notifications_none_rounded;
        color = Colors.grey;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: actualIconSize),
    );
  }
}
