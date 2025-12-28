import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';
import 'package:studydocs/features/notification/presentation/component/helpers/notification_modal_size_helper.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_modal_action.dart';
import 'package:studydocs/features/notification/presentation/notification_trash_screen.dart';

import '../base/notification_modal_layout.dart';

/// Modal chính cho trang notifications (hiển thị khi nhấn nút "...")
/// - Action "Đánh dấu tất cả đã đọc": cập nhật trạng thái tất cả notifications
/// - Action "Thông báo đã xóa": chuyển đến trang thùng rác
/// Sử dụng BLoC để quản lý các thao tác với notifications
class NotificationNormalModal extends StatelessWidget {
  final String userId;

  const NotificationNormalModal({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final sizes = NotificationModalSizeHelper.calculate(context);

    return NotificationModalLayout(
      child: Column(
        children: [
          NotificationModalAction(
            label: "Đánh dấu tất cả đã đọc",
            asset: AppAssets.markAsRead,
            size: sizes.clampedButtonIconSize,
            onPressed: () {
              context.read<NotificationBloc>().add(MarkAllAsReadEvent());
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              });
            },
          ),
          NotificationModalAction(
            label: "Thông báo đã xóa",
            asset: AppAssets.bin,
            size: sizes.clampedButtonIconSize,
              onPressed: () async {
              // Capture the parent bloc and navigator before closing the modal to avoid using a disposed context
              final parentBloc = context.read<NotificationBloc>();
              final navigator = Navigator.of(context);
              // Close modal
              navigator.pop();
              // Navigate to Trash screen with the same bloc
              final result = await navigator.push<bool?>(
                MaterialPageRoute(
                  builder: (_) => NotificationTrashScreen(userId: userId, parentBloc: parentBloc),
                ),
              );

              // If the trash screen returned true (something changed), reload main list
              if (result == true) {
                // Ask the current NotificationBloc to reload non-deleted notifications
                parentBloc.add(const LoadNotificationEvent(isDeleted: false));
              }
            },
          ),
        ],
      ),
    );
  }
}
