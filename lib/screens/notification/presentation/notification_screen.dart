import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/data/model/notification_model.dart';
import '../logic/notification_bloc.dart';
import '../logic/notification_event.dart';
import '../logic/notification_state.dart';
import 'package:studydocs/core/widgets/feat/notification/presentation/widgets/active_notification_list.dart';
import 'package:studydocs/core/widgets/feat/notification/presentation/widgets/trash_notification_list.dart';
import 'package:studydocs/core/widgets/feat/notification/presentation/widgets/notification_options_bottom_sheet.dart';
import 'package:studydocs/core/widgets/feat/notification/presentation/widgets/notification_header_widget.dart';
import 'package:studydocs/core/widgets/feat/notification/presentation/widgets/notification_detail_widget.dart';
import 'package:studydocs/core/widgets/feat/notification/presentation/widgets/global_notification_options_bottom_sheet.dart';

import '../data/repository/notification_remote_repository.dart';

import 'package:studydocs/data/datasource/impl/notification_remote_datasource_impl.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final dataSource = NotificationRemoteDataSourceImpl();
        final repository = NotificationRemoteRepository(dataSource);
        return NotificationBloc(
          repository: repository,
        )..add(FetchNotificationsEvent());
      },
      child: const NotificationView(),
    );
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  void _showDetail(BuildContext context, NotificationModel note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (ctx) => NotificationDetailWidget(notification: note),
    );
  }

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
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  NotificationHeaderWidget(
                    title: state.isTrashMode ? 'Thùng rác' : 'Thông báo',
                    onMoreTap: () => state.isTrashMode 
                      ? context.read<NotificationBloc>().add(ToggleTrashModeEvent())
                      : _showGlobalOptions(context),
                  ),
                  Expanded(
                    child: state.isTrashMode
                        ? TrashNotificationList(
                            trashList: state.trashNotifications,
                            selectedTrashIds: state.selectedTrashIds,
                            isSelectionMode: state.isSelectionMode,
                            onToggleSelection: (id) => context.read<NotificationBloc>().add(ToggleTrashSelectionEvent(id)),
                            onRestore: (id) => context.read<NotificationBloc>().add(RestoreNotificationEvent(id)),
                            onDelete: (id) => context.read<NotificationBloc>().add(DeleteNotificationPermanentlyEvent(id)),
                            onRestoreAllSelected: () => context.read<NotificationBloc>().add(RestoreAllSelectedEvent()),
                            onDeleteAllSelected: () => context.read<NotificationBloc>().add(DeleteAllSelectedEvent()),
                            onEnterSelectionMode: (id) => context.read<NotificationBloc>().add(ToggleSelectionModeEvent(isSelectionMode: true, initialId: id)),
                          )
                        : ActiveNotificationList(
                            notifications: state.activeNotifications,
                            onTrashTap: (id) => context.read<NotificationBloc>().add(MoveNotificationToTrashEvent(id)),
                            onNotificationTap: (note) {
                               context.read<NotificationBloc>().add(MarkNotificationAsReadEvent(note.id));
                               _showDetail(context, note);
                            },
                            onMoreTap: (note) => _showOptions(context, note),
                            onGlobalMoreTap: () => _showGlobalOptions(context),
                          ),
                  ),
                ],
              ),
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
