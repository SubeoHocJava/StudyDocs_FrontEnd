import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';
import '../domain/repository/notification_repository.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc({
    required this.repository,
  }) : super(NotificationInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<ToggleTrashModeEvent>(_onToggleTrashMode);
    on<ToggleTrashSelectionEvent>(_onToggleTrashSelection);
    on<RestoreAllSelectedEvent>(_onRestoreAllSelected);
    on<DeleteAllSelectedEvent>(_onDeleteAllSelected);
    on<ToggleSelectionModeEvent>(_onToggleSelectionMode);
    on<ClearSelectionEvent>(_onClearSelection);
    on<MarkNotificationAsReadEvent>(_onMarkAsRead);
    on<MoveNotificationToTrashEvent>(_onMoveToTrash);
    on<RestoreNotificationEvent>(_onRestore);
    on<DeleteNotificationPermanentlyEvent>(_onDelete);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
    on<MoveAllToTrashEvent>(_onMoveAllToTrash);
  }

  Future<void> _onFetchNotifications(FetchNotificationsEvent event, Emitter<NotificationState> emit) async {
    // Only show loading if we don't have existing data to avoid flicker
    if (state is! NotificationLoaded) {
      emit(NotificationLoading());
    }
    
    try {
      final activeList = await repository.getNotifications();
      final trashList = await repository.getTrashNotifications();
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        emit(currentState.copyWith(
          activeNotifications: activeList,
          trashNotifications: trashList,
        ));
      } else {
        emit(NotificationLoaded(
          activeNotifications: activeList, 
          trashNotifications: trashList,
        ));
      }
    } catch (_) {
      emit(const NotificationError("Không thể tải thông báo"));
    }
  }

  void _onToggleTrashMode(ToggleTrashModeEvent event, Emitter<NotificationState> emit) {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      emit(currentState.copyWith(
        isTrashMode: !currentState.isTrashMode, 
        selectedTrashIds: [],
        isSelectionMode: false,
      ));
    }
  }

  void _onToggleSelectionMode(ToggleSelectionModeEvent event, Emitter<NotificationState> emit) {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final newMode = event.isSelectionMode ?? !currentState.isSelectionMode;
      
      List<String> newSelected = List.from(currentState.selectedTrashIds);
      if (newMode && event.initialId != null) {
        if (!newSelected.contains(event.initialId!)) {
          newSelected.add(event.initialId!);
        }
      } else if (!newMode) {
        newSelected = [];
      }
      
      emit(currentState.copyWith(
        isSelectionMode: newMode,
        selectedTrashIds: newSelected,
      ));
    }
  }

  void _onClearSelection(ClearSelectionEvent event, Emitter<NotificationState> emit) {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      emit(currentState.copyWith(selectedTrashIds: [], isSelectionMode: false));
    }
  }

  void _onToggleTrashSelection(ToggleTrashSelectionEvent event, Emitter<NotificationState> emit) {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final selectedList = List<String>.from(currentState.selectedTrashIds);
      
      if (selectedList.contains(event.id)) {
        selectedList.remove(event.id);
      } else {
        selectedList.add(event.id);
      }
      
      // Auto-enter selection mode if we picked something
      emit(currentState.copyWith(
        selectedTrashIds: selectedList,
        isSelectionMode: selectedList.isNotEmpty,
      ));
    }
  }

  Future<void> _onDeleteAllSelected(DeleteAllSelectedEvent event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final idsToDelete = currentState.selectedTrashIds.isNotEmpty 
          ? List<String>.from(currentState.selectedTrashIds)
          : currentState.trashNotifications.map((n) => n.id).toList();
          
      for (var id in idsToDelete) {
        await repository.deletePermanently(id);
      }
      
      emit(currentState.copyWith(
        selectedTrashIds: [],
        isSelectionMode: false,
      ));
      add(FetchNotificationsEvent());
    }
  }

  Future<void> _onRestoreAllSelected(RestoreAllSelectedEvent event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final idsToRestore = currentState.selectedTrashIds.isNotEmpty 
          ? List<String>.from(currentState.selectedTrashIds)
          : currentState.trashNotifications.map((n) => n.id).toList();

      for (var id in idsToRestore) {
        await repository.restoreFromTrash(id);
      }

      emit(currentState.copyWith(
        selectedTrashIds: [],
        isSelectionMode: false,
      ));
      add(FetchNotificationsEvent());
    }
  }

  Future<void> _onMarkAsRead(MarkNotificationAsReadEvent event, Emitter<NotificationState> emit) async {
    try {
      await repository.markAsRead(event.id);
      add(FetchNotificationsEvent());
    } catch (_) {}
  }

  Future<void> _onMarkAllAsRead(MarkAllAsReadEvent event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      for (var note in currentState.activeNotifications) {
        if (!note.isRead) {
          await repository.markAsRead(note.id);
        }
      }
      add(FetchNotificationsEvent());
    }
  }

  Future<void> _onMoveAllToTrash(MoveAllToTrashEvent event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      for (var note in currentState.activeNotifications) {
        await repository.moveToTrash(note.id);
      }
      add(FetchNotificationsEvent());
    }
  }

  Future<void> _onMoveToTrash(MoveNotificationToTrashEvent event, Emitter<NotificationState> emit) async {
    try {
      await repository.moveToTrash(event.id);
      add(FetchNotificationsEvent());
    } catch (_) {}
  }

  Future<void> _onRestore(RestoreNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      await repository.restoreFromTrash(event.id);
      add(FetchNotificationsEvent());
    } catch (_) {}
  }

  Future<void> _onDelete(DeleteNotificationPermanentlyEvent event, Emitter<NotificationState> emit) async {
    try {
      await repository.deletePermanently(event.id);
      add(FetchNotificationsEvent());
    } catch (_) {}
  }
}

