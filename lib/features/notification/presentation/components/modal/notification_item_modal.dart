import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';
import 'package:studydocs/features/notification/models/notification.dart';

import 'notification_modal_layout.dart';
import 'parts/helpers/notification_modal_size_helper.dart';
import 'parts/notification_modal_action.dart';
import 'parts/notification_modal_content.dart';

class NotificationItemModal extends StatelessWidget {
  final AppNotification notification;

  const NotificationItemModal({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sizes = NotificationModalSizeHelper.calculate(screenWidth);

    return NotificationModalLayout(
      child: Column(
        children: [
          NotificationModalContent(
            notification: notification,
            iconSize: sizes.clampedIconSize,
            fontSize: sizes.clampedFontSize,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NotificationModalAction(
                label: "Đánh dấu đã đọc",
                asset: AppAssets.markAsRead,
                size: sizes.clampedButtonIconSize,
                onPressed: () {
                  context.read<NotificationBloc>().add(
                    MarkAsReadEvent(notification.id),
                  );
                  Navigator.pop(context);
                },
              ),
              NotificationModalAction(
                label: "Xóa thông báo này",
                asset: AppAssets.bin,
                size: sizes.clampedSmallButtonIconSize,
                onPressed: () {
                  context.read<NotificationBloc>().add(
                    DeleteNotificationEvent(notification.id, DeleteType.soft),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
