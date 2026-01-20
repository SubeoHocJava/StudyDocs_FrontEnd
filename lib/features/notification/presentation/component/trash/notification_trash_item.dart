import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_item_metadata.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_item_text.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_modal_action.dart';
import 'package:studydocs/features/notification/presentation/component/helpers/notification_layout_helper.dart';
import 'package:studydocs/features/notification/presentation/component/helpers/notification_press_state_mixin.dart';

import 'notification_trash_item_modal.dart';

class NotificationTrashItem extends StatefulWidget {
  final NotificationEntity notification;
  final bool isChecked;
  final void Function(String id, bool isChecked)? onCheck;
  final VoidCallback? onRestore;
  final VoidCallback? onDelete;

  const NotificationTrashItem({
    super.key,
    required this.notification,
    this.isChecked = false,
    this.onCheck,
    this.onRestore,
    this.onDelete,
  });

  @override
  State<NotificationTrashItem> createState() => _NotificationTrashItemState();
}

class _NotificationTrashItemState extends State<NotificationTrashItem>
    with NotificationPressStateMixin {

  Color _backgroundColor(BuildContext context) {
    final unreadColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.notificationUnreadDark
        : AppColors.notificationUnreadLight;

    if (isPressed) {
      return unreadColor.withValues(alpha: 0.6);
    }
    if (widget.isChecked) {
      return unreadColor.withValues(alpha: 0.15);
    }
    return Theme.of(context).cardColor;
  }

  void _toggleCheck() {
    if (widget.onCheck == null) return;
    widget.onCheck!(widget.notification.id, !widget.isChecked);
  }

  void _showModal() {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) => NotificationTrashItemModal(
        notification: widget.notification,
        onRestore: () => widget.onRestore?.call(),
        onDelete: () => widget.onDelete?.call(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final layout = NotificationLayoutHelper.calculate(context);

    return Material(
      color: _backgroundColor(context),
      child: InkWell(
        onTap: _toggleCheck,
        onTapDown: (_) => handlePressDown(),
        onTapUp: (_) => handlePressUp(),
        onTapCancel: handlePressCancel,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: layout.horizontalPadding,
            vertical: layout.verticalPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationTypeIcon(
                type: widget.notification.type,
                size: layout.iconSize,
              ),
              SizedBox(width: layout.spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NotificationItemText(
                      content: widget.notification.body,
                      fontSize: layout.fontSize,
                    ),
                    NotificationItemMetadata(
                      notification: widget.notification,
                      fontSize: layout.metaFontSize,
                    ),
                  ],
                ),
              ),
              // Checkbox and More Button
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Checkbox(
                    value: widget.isChecked,
                    onChanged: (value) {
                       widget.onCheck?.call(
                        widget.notification.id,
                        value ?? false,
                      );
                    },
                  ),
                  IconButton(
                    onPressed: _showModal,
                    icon: Image.asset(AppAssets.moreHoriz),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

