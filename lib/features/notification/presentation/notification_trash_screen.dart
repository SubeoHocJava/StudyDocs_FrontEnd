import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification/domain/repository/notification_repository.dart';
import 'package:studydocs/features/notification/logic/notification_bloc.dart';
import 'package:studydocs/features/notification/logic/notification_enum.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';
import 'package:studydocs/features/notification/logic/notification_state.dart';

import 'component/base/notification_section.dart';
import 'component/trash/notification_trash_modal.dart';
import 'helper/notification_helper.dart';
import 'shared/notification_page_layout.dart';

class NotificationTrashScreen extends StatefulWidget {
  final String userId;
  final NotificationBloc? parentBloc;

  const NotificationTrashScreen({super.key, required this.userId, this.parentBloc});

  @override
  State<NotificationTrashScreen> createState() =>
      _NotificationTrashScreenState();
}

class _NotificationTrashScreenState extends State<NotificationTrashScreen> {
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    if (widget.parentBloc != null) {
      widget.parentBloc!.add(const LoadNotificationEvent(isDeleted: true));
    }
  }

  void _handleCheck(String id, bool checked) {
    setState(() {
      checked ? _selectedIds.add(id) : _selectedIds.remove(id);
    });
  }

  void _showTrashModal(BuildContext ctx) {
    final bloc = ctx.read<NotificationBloc>();
    showModalBottomSheet(
      context: ctx,
        barrierColor: Colors.black.withOpacity(0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: ctx.read<NotificationBloc>(),
        child: NotificationTrashModal(
          selectedIds: _selectedIds.toList(),
          onRestore: () {
            if (_selectedIds.isEmpty) return;
            bloc.add(RestoreNotificationEvent(_selectedIds.toList()));
            setState(() => _selectedIds.clear());
            // Close the modal
            Navigator.of(ctx).pop();
            // Pop the trash screen from the root navigator and return 'true' to indicate changes
            Navigator.of(ctx, rootNavigator: true).pop(true);
          },
          onHardDelete: () {
            if (_selectedIds.isEmpty) return;
            bloc.add(
              DeleteNotificationEvent(
                _selectedIds.toList(),
                DeleteType.hard,
              ),
            );
            setState(() => _selectedIds.clear());
            // Close the modal after hard delete
            Navigator.pop(ctx);
          },
          onClearAll: () {
            // Clear selection and close modal
            setState(() => _selectedIds.clear());
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If parentBloc present, use it; otherwise create local one
    if (widget.parentBloc != null) {

      return BlocProvider.value(
        value: widget.parentBloc!,
        child: Builder(
          builder: (context) {
            return BlocListener<NotificationBloc, NotificationState>(
              listener: (context, state) {
                if (state is NotificationLoadedState) {
                  debugPrint('Trash screen loaded ${state.deletedNotifications.length} items');
                  if (state.deletedNotifications.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thùng rác trống')));
                  }
                }
              },
              child: NotificationPageLayout(
                userId: widget.userId,
                isDeleted: true,
                emptyMessage: "Chưa có dữ liệu",
                // Header config
                isDefault: false,
                headerTitle: "Thùng rác",
                onBack: () => Navigator.pop(context),
                // Header config end
                childBuilder: (notifications) {
                  final sections = NotificationHelper.buildSections(notifications);
                  return ListView.builder(
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      final section = sections[index];
                      return NotificationSection(
                        title: section.title,
                        notifications: section.items,
                        type: NotificationSectionType.trash,
                        selectedIds: _selectedIds.toList(),
                        onCheck: _handleCheck,
                      );
                    },
                  );
                },
                onModal: (BuildContext ctx) => _showTrashModal(ctx),
              ),
            );
          },
        ),
      );
    }

    return BlocProvider(
      create: (
          _) =>
              NotificationBloc(context.read<NotificationRepository>())
                ..add(const LoadNotificationEvent(isDeleted: true)),
      child: Builder(
        builder: (context) {
          return BlocListener<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state is NotificationLoadedState) {
                debugPrint('Trash screen loaded ${state.deletedNotifications.length} items');
                if (state.deletedNotifications.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thùng rác trống')));
                }
              }
            },
            child: NotificationPageLayout(
              userId: widget.userId,
              isDeleted: true,
              emptyMessage: "Chưa có dữ liệu",
              // Header config
              isDefault: false,
              headerTitle: "Thùng rác",
              onBack: () => Navigator.pop(context),
              // Header config end
              childBuilder: (notifications) {
                final sections = NotificationHelper.buildSections(notifications);
                return ListView.builder(
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    return NotificationSection(
                      title: section.title,
                      notifications: section.items,
                      type: NotificationSectionType.trash,
                      selectedIds: _selectedIds.toList(),
                      onCheck: _handleCheck,
                    );
                  },
                );
              },
              onModal: (BuildContext ctx) => _showTrashModal(ctx),
            ),
          );
        },
      ),
    );
  }
}
