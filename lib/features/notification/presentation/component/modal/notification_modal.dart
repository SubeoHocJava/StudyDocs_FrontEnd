import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';

import 'notification_modal_layout.dart';
import '../helpers/notification_modal_size_helper.dart';
import '../shared/notification_shared.dart';

/// Modal chính cho trang notifications (hiển thị khi nhấn nút "...")
/// - Action "Đánh dấu tất cả đã đọc": cập nhật trạng thái tất cả notifications
/// - Action "Thông báo đã xóa": chuyển đến trang thùng rác
/// Sử dụng BLoC để quản lý các thao tác với notifications
class NotificationModal extends StatelessWidget {
  const NotificationModal({super.key});

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
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
