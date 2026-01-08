import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_modal_layout.dart';
import 'package:studydocs/features/notification/presentation/component/helpers/notification_modal_size_helper.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_modal_action.dart';

class NotificationTrashModal extends StatelessWidget {
  final List<String> selectedIds;
  final VoidCallback onRestore;
  final VoidCallback onHardDelete;

  const NotificationTrashModal({
    super.key,
    required this.selectedIds,
    required this.onRestore,
    required this.onHardDelete,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = NotificationModalSizeHelper.calculate(context);

    return NotificationModalLayout(
      child: Column(
        children: [
          NotificationModalAction(
            label: "Khôi phục thông báo",
            icon: Icons.restore_from_trash_outlined,
            size: sizes.clampedButtonIconSize,
            onPressed: () {
              onRestore();
            },
          ),
          NotificationModalAction(
            label: "Xóa thông báo vĩnh viễn",
            icon: Icons.delete_forever_outlined,
            size: sizes.clampedButtonIconSize,
            onPressed: () {
              onHardDelete();
            },
          ),
        ],
      ),
    );
  }
}
