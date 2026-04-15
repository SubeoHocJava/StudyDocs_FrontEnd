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
import 'widgets/notification_header_widget.dart';
import 'widgets/notification_detail_widget.dart';
import 'widgets/global_notification_options_bottom_sheet.dart';

class NotificationPresentation extends StatelessWidget {
  const NotificationPresentation({super.key});

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
            backgroundColor: AppColors.backgroundLight,
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
            bottomNavigationBar: _buildBottomNav(context, state.activeNotifications.where((n) => !n.isRead).length),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Thông báo')),
          body: const Center(child: Text("Đã có lỗi xảy ra")),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context, int unreadCount) {
    return BottomNavigationBar(
      currentIndex: 3, // Notification tab
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
        const BottomNavigationBarItem(icon: Icon(Icons.library_books_outlined), label: 'Thư viện'),
        const BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Khám phá'),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              if (unreadCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          label: 'Thông báo',
        ),
      ],
    );
  }
}