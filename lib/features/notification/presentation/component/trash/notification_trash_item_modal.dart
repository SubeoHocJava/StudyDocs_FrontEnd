import 'package:flutter/material.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_modal_layout.dart';
import 'package:studydocs/features/notification/presentation/component/helpers/notification_modal_size_helper.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_modal_action.dart';


class NotificationTrashItemModal extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const NotificationTrashItemModal({
    super.key,
    required this.notification,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = NotificationModalSizeHelper.calculate(context);

    return NotificationModalLayout(
      child: Column(
        children: [
          _NotificationModalContent(
            notification: notification,
            iconSize: sizes.clampedIconSize,
            fontSize: sizes.clampedFontSize,
          ),
          Column(
            children: [
              NotificationModalAction(
                label: "Khôi phục thông báo",
                icon: Icons.restore_from_trash_outlined,
                size: sizes.clampedButtonIconSize,
                onPressed: () {
                  onRestore();
                  Navigator.pop(context);
                },
              ),
              NotificationModalAction(
                label: "Xóa vĩnh viễn",
                icon: Icons.delete_forever_outlined,
                size: sizes.clampedButtonIconSize,
                onPressed: () {
                  onDelete();
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

class _NotificationModalContent extends StatelessWidget {
  final NotificationEntity notification;
  final double iconSize;
  final double fontSize;

  const _NotificationModalContent({
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
          notification.body,
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
