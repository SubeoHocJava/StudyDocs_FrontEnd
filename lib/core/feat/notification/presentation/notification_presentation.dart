import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import '../domain/entity/notification_model.dart';
import '../logic/notification_bloc.dart';
import '../logic/notification_event.dart';
import '../logic/notification_state.dart';
import 'widgets/active_notification_list.dart';
import 'widgets/trash_notification_list.dart';
import 'widgets/notification_options_bottom_sheet.dart';
import 'widgets/global_notification_options_bottom_sheet.dart';

class NotificationPresentation extends StatelessWidget {
  const NotificationPresentation({super.key});

  void _showOptions(BuildContext context, NotificationModel note) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (ctx) => NotificationOptionsBottomSheet(
        notification: note,
        onMarkAsRead: () {
          context.read<NotificationBloc>().add(MarkNotificationAsReadEvent(note.id));
        },
        onDelete: () {
          context.read<NotificationBloc>().add(MoveNotificationToTrashEvent(note.id));
        },
      ),
    );
  }

  void _showGlobalOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (ctx) => GlobalNotificationOptionsBottomSheet(
        onMarkAllAsRead: () {
          context.read<NotificationBloc>().add(MarkAllAsReadEvent());
        },
        onDeleteAll: () {
          context.read<NotificationBloc>().add(MoveAllToTrashEvent());
        },
        onViewTrash: () {
          context.read<NotificationBloc>().add(ToggleTrashModeEvent());
        },
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
            backgroundColor: AppColors.backgroundLight,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundLight,
              elevation: 0,
              title: Text(
                state.isTrashMode ? 'Thùng rác' : 'Thông báo',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              leading: state.isTrashMode
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        context.read<NotificationBloc>().add(ToggleTrashModeEvent());
                      },
                    )
                  : null,
            ),
            body: state.isTrashMode
                ? TrashNotificationList(
                    trashList: state.trashNotifications,
                    selectedTrashIds: state.selectedTrashIds,
                    onToggleSelection: (id) => context.read<NotificationBloc>().add(ToggleTrashSelectionEvent(id)),
                    onRestore: (id) => context.read<NotificationBloc>().add(RestoreNotificationEvent(id)),
                    onDelete: (id) => context.read<NotificationBloc>().add(DeleteNotificationPermanentlyEvent(id)),
                    onRestoreAllSelected: () => context.read<NotificationBloc>().add(RestoreAllSelectedEvent()),
                    onDeleteAllSelected: () => context.read<NotificationBloc>().add(DeleteAllSelectedEvent()),
                  )
                : ActiveNotificationList(
                    notifications: state.activeNotifications,
                    onTrashTap: () {}, // Handled by Slidable
                    onNotificationTap: (note) => _showOptions(context, note),
                    onMoreTap: (note) => _showOptions(context, note),
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