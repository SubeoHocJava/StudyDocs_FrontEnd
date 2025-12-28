import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_modal_action.dart';

import '../helpers/notification_layout_helper.dart';
import '../helpers/notification_press_state_mixin.dart';
import '../base/notification_item_metadata.dart';
import '../base/notification_item_text.dart';

class NotificationTrashItem extends StatefulWidget {
  final NotificationEntity notification;
  final void Function(String id, bool isChecked)? onCheck;
  final VoidCallback? onRestore;
  final VoidCallback? onDelete;

  const NotificationTrashItem({
    super.key,
    required this.notification,
    this.onCheck,
    this.onRestore,
    this.onDelete,
  });

  @override
  State<NotificationTrashItem> createState() => _NotificationTrashItemState();
}

class _NotificationTrashItemState extends State<NotificationTrashItem>
    with NotificationPressStateMixin {
  bool _isChecked = false;

  Color _backgroundColor(BuildContext context) {
    if (isPressed) {
      return AppColors.notificationUnread.withValues(alpha: 0.6);
    }
    if (_isChecked) {
      return AppColors.notificationUnread.withValues(alpha: 0.15);
    }
    return Theme.of(context).cardColor;
  }

  void _toggleCheck() {
    if (widget.onCheck == null) return;

    setState(() {
      _isChecked = !_isChecked;
      widget.onCheck!(widget.notification.id, _isChecked);
    });
  }

  void _resetCheck() {
    if (!_isChecked) return;
    setState(() => _isChecked = false);
    widget.onCheck?.call(widget.notification.id, false);
  }

  @override
  Widget build(BuildContext context) {
    final layout = NotificationLayoutHelper.calculate(context);

    return Slidable(
      key: ValueKey(widget.notification.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (_) {
              _resetCheck();
              widget.onRestore?.call();
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh),
                const SizedBox(height: 4),
                Text('Khôi phục', style: TextStyle(fontSize: layout.metaFontSize)),
              ],
            ),
          ),
          CustomSlidableAction(
            onPressed: (_) {
              _resetCheck();
              widget.onDelete?.call();
            },
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF000F4C),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.delete_forever, color: Color(0xFF000F4C)),
                const SizedBox(height: 4),
                Text('Xóa', style: TextStyle(fontSize: layout.metaFontSize)),
              ],
            ),
          ),
        ],
      ),
      child: Material(
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
                SizedBox(width: layout.spacing),
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value ?? false;
                      widget.onCheck?.call(
                        widget.notification.id,
                        _isChecked,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
