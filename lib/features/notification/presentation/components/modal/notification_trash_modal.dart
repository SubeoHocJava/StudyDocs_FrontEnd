import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';

import 'notification_modal_layout.dart';
import 'parts/helpers/notification_modal_size_helper.dart';
import 'parts/notification_modal_action.dart';

class NotificationTrashModal extends StatelessWidget {
  const NotificationTrashModal({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sizes = NotificationModalSizeHelper.calculate(screenWidth);

    return NotificationModalLayout(
      child: Column(
        children: [
          NotificationModalAction(
            label: "Khôi phục thông báo",
            asset: AppAssets.markAsRead,
            size: sizes.clampedButtonIconSize,
            onPressed: () {
              context.read<NotificationBloc>().add(MarkAllAsReadEvent());
              Navigator.pop(context);
            },
          ),
          NotificationModalAction(
            label: "Xóa thông báo vĩnh viễn",
            asset: AppAssets.bin,
            size: sizes.clampedButtonIconSize,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
