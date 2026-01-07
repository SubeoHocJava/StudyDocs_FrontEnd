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

  const NotificationTrashScreen({
    super.key,
    required this.userId,
    this.parentBloc,
  });

  @override
  State<NotificationTrashScreen> createState() => _NotificationTrashScreenState();
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

  void _restore(NotificationBloc bloc) {
    if (_selectedIds.isEmpty) return;
    bloc.add(RestoreNotificationEvent(_selectedIds.toList()));
    setState(() => _selectedIds.clear());
    Navigator.pop(context);
  }

  void _hardDelete(NotificationBloc bloc) {
    if (_selectedIds.isEmpty) return;
    bloc.add(DeleteNotificationEvent(_selectedIds.toList(), DeleteType.hard));
    setState(() => _selectedIds.clear());
    Navigator.pop(context);
  }

  void _toggleSelectAll(bool? value, NotificationState state) {
    if (state is NotificationLoadedState) {
      setState(() {
        if (value == true) {
          _selectedIds.addAll(state.deletedNotifications.map((e) => e.id));
        } else {
          _selectedIds.clear();
        }
      });
    }
  }

  void _showTrashModal(BuildContext ctx) {
    final bloc = ctx.read<NotificationBloc>();
    showModalBottomSheet(
      context: ctx,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: NotificationTrashModal(
          selectedIds: _selectedIds.toList(),
          onRestore: () => _restore(bloc),
          onHardDelete: () => _hardDelete(bloc),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = widget.parentBloc != null
        ? BlocProvider.value(value: widget.parentBloc!, child: _buildBody())
        : BlocProvider(
      create: (_) => NotificationBloc(
        context.read<NotificationRepository>(),
      )..add(const LoadNotificationEvent(isDeleted: true)),
      child: _buildBody(),
    );

    return blocProvider;
  }

  Widget _buildBody() {
    return Builder(
      builder: (context) {
        return BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationLoadedState &&
                state.deletedNotifications.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thùng rác trống')),
              );
            }
          },
          child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              return NotificationPageLayout(
                userId: widget.userId,
                isDeleted: true,
                emptyMessage: "Thùng rác trống",
                isDefault: false,
                headerTitle: "Thùng rác",
                childBuilder: (notifications) {
                  final sections =
                  NotificationHelper.buildSections(notifications);
                  final allDeletedIds =
                  notifications.map((e) => e.id).toSet();
                  final isAllSelected = notifications.isNotEmpty &&
                      allDeletedIds.every(_selectedIds.contains);

                  return Column(
                    children: [
                      if (notifications.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap:
                                    () =>
                                        _toggleSelectAll(!isAllSelected, state),
                                borderRadius: BorderRadius.circular(4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: isAllSelected,
                                        onChanged:
                                            (val) =>
                                                _toggleSelectAll(val, state),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        side: const BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Chọn tất cả",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_selectedIds.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    "${_selectedIds.length} mục",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: sections.length,
                          itemBuilder: (context, index) {
                            final section = sections[index];
                            return NotificationSection(
                              title: section.title,
                              notifications: section.items,
                              type: NotificationSectionType.trash,
                              selectedIds: _selectedIds.toList(),
                              onCheck: _handleCheck,
                              onRestore: (id) {
                                context.read<NotificationBloc>().add(
                                  RestoreNotificationEvent([id]),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                    Text('Khôi phục thông báo thành công'),
                                  ),
                                );
                              },
                              onHardDelete: (id) {
                                context.read<NotificationBloc>().add(
                                  DeleteNotificationEvent(
                                    [id],
                                    DeleteType.hard,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                onModal: (BuildContext ctx) => _showTrashModal(ctx),
              );
            },
          ),
        );
      },
    );
  }
}
