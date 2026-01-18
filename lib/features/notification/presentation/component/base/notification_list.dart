import 'package:flutter/material.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/presentation/component/normal/notification_item.dart';
import 'package:studydocs/features/notification/presentation/component/trash/notification_trash_item.dart';


class NotificationList extends StatelessWidget {
  final List<NotificationEntity> notifications;
  final void Function(String id) onDelete;

  const NotificationList({
    super.key,
    required this.notifications,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];

        return Dismissible(
          key: ValueKey(item.id),
          direction: DismissDirection.endToStart,
          background: _deleteBackground(),
          onDismissed: (_) => onDelete(item.id),
          child: NotificationItem(notification: item),
        );
      },
    );
  }

  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: Colors.redAccent,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}


class NotificationTrashList extends StatelessWidget {
  final List<NotificationEntity> notifications;
  final List<String> selectedIds;
  final void Function(String id, bool checked)? onCheck;
  final void Function(String id)? onRestore;
  final void Function(String id)? onDelete;

  const NotificationTrashList({
    super.key,
    required this.notifications,
    this.selectedIds = const [],
    this.onCheck,
    this.onRestore,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        final isChecked = selectedIds.contains(item.id);

        return NotificationTrashItem(
          key: ValueKey(item.id),
          notification: item,
          isChecked: isChecked,
          onCheck: onCheck,
          onRestore: () => onRestore?.call(item.id),
          onDelete: () => onDelete?.call(item.id),
        );
      },
    );
  }
}
