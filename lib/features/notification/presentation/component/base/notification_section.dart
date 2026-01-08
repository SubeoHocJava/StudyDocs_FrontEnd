import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_enum.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_list.dart';

class NotificationSection extends StatelessWidget {
  final String title;
  final List<NotificationEntity> notifications;
  final NotificationSectionType type;
  final List<String> selectedIds;
  final void Function(String id, bool checked)? onCheck;
  final void Function(String id)? onRestore;
  final void Function(String id)? onHardDelete;
  final void Function(String id)? onSoftDelete;

  const NotificationSection({
    super.key,
    required this.title,
    required this.notifications,
    required this.type,
    this.selectedIds = const [],
    this.onCheck,
    this.onRestore,
    this.onHardDelete,
    this.onSoftDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (NotificationSectionType.normal == type)
          _SectionHeader(title: title),
        _SectionBody(
          notifications: notifications,
          type: type,
          selectedIds: selectedIds,
          onCheck: onCheck,
          onRestore: onRestore,
          onHardDelete: onHardDelete,
          onSoftDelete: onSoftDelete,
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: responsive.fontSize(16),
            ),
      ),
    );
  }
}

class _SectionBody extends StatelessWidget {
  final List<NotificationEntity> notifications;
  final NotificationSectionType type;
  final List<String> selectedIds;
  final void Function(String id, bool checked)? onCheck;
  final void Function(String id)? onRestore;
  final void Function(String id)? onHardDelete;
  final void Function(String id)? onSoftDelete;

  const _SectionBody({
    required this.notifications,
    required this.type,
    this.selectedIds = const [],
    this.onCheck,
    this.onRestore,
    this.onHardDelete,
    this.onSoftDelete,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case NotificationSectionType.normal:
        return NotificationList(
          notifications: notifications,
          onDelete: (id) => onSoftDelete?.call(id),
        );

      case NotificationSectionType.trash:
        return NotificationTrashList(
          notifications: notifications,
          selectedIds: selectedIds,
          onCheck: onCheck,
          onRestore: onRestore,
          onDelete: onHardDelete,
        );
    }
  }
}
