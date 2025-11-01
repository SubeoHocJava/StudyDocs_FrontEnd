import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../../core/constants/app_icons.dart';

class NotificationTypeStore {
  static NotificationType LIKE = NotificationType(
    "LIKE",
    Color.fromRGBO(5, 5, 196, 1),
    AppAssets.like,
  );
  static NotificationType DOWNLOAD = NotificationType(
    "DOWNLOAD",
    Color.fromRGBO(0, 126, 90, 1),
    AppAssets.download,
  );
  static final Map<String, NotificationType> types = {
    LIKE.type: LIKE,
    DOWNLOAD.type: DOWNLOAD,
  };

  static NotificationType? fromType(String type) {
    return types[type.toUpperCase()];
  }
}

class NotificationType {
  final String type;
  final Color backgroundColor;
  final String src;

  NotificationType(this.type, this.backgroundColor, this.src);
}
