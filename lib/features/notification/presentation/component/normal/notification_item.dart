import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_enum.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_modal_action.dart';

import '../helpers/notification_layout_helper.dart';
import '../helpers/notification_press_state_mixin.dart';
import 'notification_normal_item_modal.dart';
import '../base/notification_item_metadata.dart';
import '../base/notification_item_text.dart';

class NotificationItem extends StatefulWidget {
  final NotificationEntity notification;

  const NotificationItem({super.key, required this.notification});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem>
    with NotificationPressStateMixin {
  Color _backgroundColor(BuildContext context) {
    if (isPressed) {
      return AppColors.notificationUnread.withOpacity(0.7);
    }
    if (!widget.notification.isRead) {
      return AppColors.notificationUnread;
    }
    return Colors.white;
  }

  void _showModal() {
    final bloc = context.read<NotificationBloc>();

    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<NotificationBloc>(),
        child: NotificationNormalItemModal(
          notification: widget.notification,
          onMarkAsRead: widget.notification.isRead
              ? null
              : () {
                  bloc.add(MarkAsReadEvent(widget.notification.id));
                },
          onDelete: () {
            bloc.add(
              DeleteNotificationEvent([
                widget.notification.id,
              ], DeleteType.soft),
            );
          },
        ),
      ),
    );
  }

  void _handleTap() {
    _showModal();
  }

  @override
  Widget build(BuildContext context) {
    final layout = NotificationLayoutHelper.calculate(context);

    return GestureDetector(
      onTap: _handleTap,
      onTapDown: (_) => handlePressDown(),
      onTapUp: (_) => handlePressUp(),
      onTapCancel: handlePressCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: layout.horizontalPadding,
          vertical: layout.verticalPadding,
        ),
        color: _backgroundColor(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                NotificationTypeIcon(
                  type: widget.notification.type,
                  size: layout.iconSize,
                ),
                if (!widget.notification.isRead)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: layout.spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NotificationItemText(
                    content: widget.notification.body,
                    fontSize: layout.fontSize,
                    isRead: widget.notification.isRead,
                  ),
                  NotificationItemMetadata(
                    notification: widget.notification,
                    fontSize: layout.metaFontSize,
                  ),
                ],
              ),
            ),
            SizedBox(width: layout.spacing),
            IconButton(
              onPressed: _showModal,
              icon: Image.asset(AppAssets.moreHoriz),
            ),
          ],
        ),
      ),
    );
  }
}
