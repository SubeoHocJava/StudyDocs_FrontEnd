import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/router/app_router.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';
import 'package:studydocs/features/notification/presentation/component/helpers/notification_modal_size_helper.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_modal_action.dart';
import 'package:go_router/go_router.dart';

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
            icon: Icons.mark_email_read_outlined,
            size: sizes.clampedButtonIconSize,
            onPressed: () {
              context.read<NotificationBloc>().add(MarkAllAsReadEvent());
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              });
            },
          ),
          NotificationModalAction(
            label: "Xóa tất cả",
            icon: Icons.delete_sweep_outlined,
            size: sizes.clampedButtonIconSize,
            onPressed: () {
               context.read<NotificationBloc>().add(DeleteAllLoadedNotificationEvent());
               WidgetsBinding.instance.addPostFrameCallback((_) {
                 Navigator.pop(context);
               });
            },
          ),
        ],
      ),
    );
  }
}
