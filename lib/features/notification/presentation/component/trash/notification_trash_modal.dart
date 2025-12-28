import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_modal_layout.dart';
import 'package:studydocs/features/notification/presentation/component/helpers/notification_modal_size_helper.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_modal_action.dart';

class NotificationTrashModal extends StatelessWidget {
  final List<String> selectedIds;
  final VoidCallback onRestore;
  final VoidCallback onHardDelete;
  final VoidCallback? onClearAll;

  const NotificationTrashModal({
    super.key,
    required this.selectedIds,
    required this.onRestore,
    required this.onHardDelete,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = NotificationModalSizeHelper.calculate(context);

    return NotificationModalLayout(
      child: Column(
        children: [
          NotificationModalAction(
            label: "Khôi phục thông báo",
            asset: AppAssets.markAsRead,
            size: sizes.clampedButtonIconSize,
            onPressed: () {
              // Delegate logic to parent (do not close modal here to avoid double pops)
              onRestore();
            },
          ),
          NotificationModalAction(
            label: "Xóa thông báo vĩnh viễn",
            asset: AppAssets.bin,
            size: sizes.clampedButtonIconSize,
            onPressed: () {
              // Delegate logic to parent (parent will close modal)
              onHardDelete();
            },
          ),
          NotificationModalAction(
            label: "Bỏ chọn tất cả",
            icon: Icons.clear_all,
            size: sizes.clampedButtonIconSize,
            onPressed: () {
              onClearAll?.call();
            },
          ),
        ],
      ),
    );
  }
}
