import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../domain/entity/notification_model.dart';
import '../logic/notification_bloc.dart';
import '../logic/notification_event.dart';
import '../logic/notification_state.dart';
// import 'widgets/active_notification_list.dart';
// import 'widgets/trash_notification_list.dart';
// import 'widgets/notification_options_bottom_sheet.dart';
// import 'widgets/global_notification_options_bottom_sheet.dart';

class NotificationPresentation extends StatelessWidget {
  const NotificationPresentation({super.key});

  void _showOptions(BuildContext context, NotificationModel note) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
    );
  }

  void _showGlobalOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is NotificationLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Thông báo'),
              leading: state.isTrashMode
                  ? IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.textPrimaryLight),
                onPressed: () {
                  context.read<NotificationBloc>().add(ToggleTrashModeEvent());
                },
              )
                  : null,
            ),
            body: state.isTrashMode
              onGlobalMoreTap: () => _showGlobalOptions(context),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Thông báo')),
          body: const Center(child: Text("Đã có lỗi xảy ra")),
        );
      },
    );
  }
}
