import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';
import '../domain/usecase/get_notifications_usecase.dart';
import '../domain/usecase/get_trash_notifications_usecase.dart';
import '../domain/usecase/mark_as_read_usecase.dart';
import '../domain/usecase/move_to_trash_usecase.dart';
import '../domain/usecase/restore_from_trash_usecase.dart';
import '../domain/usecase/delete_permanently_usecase.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotifications;
  final GetTrashNotificationsUseCase getTrashNotifications;
  final MarkAsReadUseCase markAsReadUseCase;
  final MoveToTrashUseCase moveToTrashUseCase;
  final RestoreFromTrashUseCase restoreFromTrashUseCase;
  final DeletePermanentlyUseCase deletePermanentlyUseCase;

  NotificationBloc({
    required this.getNotifications,
    required this.getTrashNotifications,
    required this.markAsReadUseCase,
    required this.moveToTrashUseCase,
    required this.restoreFromTrashUseCase,
    required this.deletePermanentlyUseCase,
  }) : super(NotificationInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<ToggleTrashModeEvent>(_onToggleTrashMode);
    on<ToggleTrashSelectionEvent>(_onToggleTrashSelection);
    on<RestoreAllSelectedEvent>(_onRestoreAllSelected);
    on<DeleteAllSelectedEvent>(_onDeleteAllSelected);
    on<MarkNotificationAsReadEvent>(_onMarkAsRead);
    on<MoveNotificationToTrashEvent>(_onMoveToTrash);
    on<RestoreNotificationEvent>(_onRestore);
    on<DeleteNotificationPermanentlyEvent>(_onDelete);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
    on<MoveAllToTrashEvent>(_onMoveAllToTrash);
  }

  Future<void> _onFetchNotifications(FetchNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final activeList = await getNotifications();
      final trashList = await getTrashNotifications();
      emit(NotificationLoaded(
        activeNotifications: activeList, 
        trashNotifications: trashList
      ));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void _onToggleTrashMode(ToggleTrashModeEvent event, Emitter<NotificationState> emit) {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      emit(currentState.copyWith(isTrashMode: !currentState.isTrashMode, selectedTrashIds: []));
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
      emit(currentState.copyWith(selectedTrashIds: selectedList));
    }
  }

  Future<void> _onRestoreAllSelected(RestoreAllSelectedEvent event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final idsToRestore = currentState.selectedTrashIds;
      for (var id in idsToRestore) {
        await restoreFromTrashUseCase(id);
      }
      add(FetchNotificationsEvent());
    }
  }

  Future<void> _onDeleteAllSelected(DeleteAllSelectedEvent event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final idsToDelete = currentState.selectedTrashIds;
      for (var id in idsToDelete) {
        await deletePermanentlyUseCase(id);
      }
      add(FetchNotificationsEvent());
    }
  }

  Future<void> _onMarkAsRead(MarkNotificationAsReadEvent event, Emitter<NotificationState> emit) async {
    try {
      await markAsReadUseCase(event.id);
      add(FetchNotificationsEvent());
    } catch (_) {}
  }

  Future<void> _onMarkAllAsRead(MarkAllAsReadEvent event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      for (var note in currentState.activeNotifications) {
        if (!note.isRead) {
          await markAsReadUseCase(note.id);
        }
      }
      add(FetchNotificationsEvent());
    }
  }

  Future<void> _onMoveAllToTrash(MoveAllToTrashEvent event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      for (var note in currentState.activeNotifications) {
        await moveToTrashUseCase(note.id);
      }
      add(FetchNotificationsEvent());
    }
  }

  Future<void> _onMoveToTrash(MoveNotificationToTrashEvent event, Emitter<NotificationState> emit) async {
    try {
      await moveToTrashUseCase(event.id);
      add(FetchNotificationsEvent());
    } catch (_) {}
  }

  Future<void> _onRestore(RestoreNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      await restoreFromTrashUseCase(event.id);
      add(FetchNotificationsEvent());
    } catch (_) {}
  }

  Future<void> _onDelete(DeleteNotificationPermanentlyEvent event, Emitter<NotificationState> emit) async {
    try {
      await deletePermanentlyUseCase(event.id);
      add(FetchNotificationsEvent());
    } catch (_) {}
  }
}

