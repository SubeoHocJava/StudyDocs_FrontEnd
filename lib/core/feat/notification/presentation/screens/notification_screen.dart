import 'package:flutter/material.dart';
import '../../domain/entity/notification_model.dart';
import '../widgets/active_notification_list.dart';
import '../widgets/trash_notification_list.dart';
import '../widgets/notification_options_bottom_sheet.dart';
import '../../../../constants/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isTrashMode = false;
  List<String> _selectedTrashIds = [];

  @override
  void initState() {
    super.initState();
    // TODO: Dispatch event to fetch notifications
    // context.read<NotificationBloc>().add(FetchNotificationsEvent());
  }

  void _markAsRead(String id) {
    // TODO: Dispatch mark as read event
    // context.read<NotificationBloc>().add(MarkNotificationAsReadEvent(id));
  }

  void _moveToTrash(String id) {
    // TODO: Dispatch move to trash event
    // context.read<NotificationBloc>().add(MoveNotificationToTrashEvent(id));
  }

  void _restoreFromTrash(String id) {
    // TODO: Dispatch restore event
    // context.read<NotificationBloc>().add(RestoreNotificationEvent(id));
  }

  void _deletePermanently(String id) {
    // TODO: Dispatch delete event
    // context.read<NotificationBloc>().add(DeleteNotificationPermanentlyEvent(id));
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedTrashIds.contains(id)) {
        _selectedTrashIds.remove(id);
      } else {
        _selectedTrashIds.add(id);
      }
    });
  }

  void _restoreAllSelected() {
    for (String id in _selectedTrashIds.toList()) {
      _restoreFromTrash(id);
    }
    setState(() {
      _selectedTrashIds.clear();
    });
  }

  void _deleteAllSelectedPermanently() {
    for (String id in _selectedTrashIds.toList()) {
      _deletePermanently(id);
    }
    setState(() {
      _selectedTrashIds.clear();
    });
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
           _markAsRead(note.id);
        },
        onDelete: () {
           _moveToTrash(note.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        leading: _isTrashMode 
            ? IconButton(icon: Icon(Icons.arrow_back, color: AppColors.textPrimaryLight), onPressed: () => setState(() => _isTrashMode = false)) 
            : null,
      ),
      body: _isTrashMode ? _buildTrashView() : _buildActiveView(),
    );
  }

  Widget _buildActiveView() {
    // TODO: Wrap with BlocBuilder<NotificationBloc, NotificationState>
    // Mocking an empty list for structural compilation, replace '[]' with state.notifications
    final List<NotificationModel> activeList = []; 
    
    return ActiveNotificationList(
      notifications: activeList,
      onTrashTap: () => setState(() => _isTrashMode = true),
      onNotificationTap: (note) {
         if (!note.isRead) _markAsRead(note.id);
      },
      onMoreTap: (note) => _showOptions(context, note),
    );
  }

  Widget _buildTrashView() {
    // TODO: Wrap with BlocBuilder<NotificationBloc, NotificationState>
    // Replace '[]' with state.trashList
    final List<NotificationModel> trashList = [];

    return TrashNotificationList(
      trashList: trashList,
      selectedTrashIds: _selectedTrashIds,
      onToggleSelection: _toggleSelection,
      onRestore: _restoreFromTrash,
      onDelete: _deletePermanently,
      onRestoreAllSelected: _restoreAllSelected,
      onDeleteAllSelected: _deleteAllSelectedPermanently,
    );
  }
}
