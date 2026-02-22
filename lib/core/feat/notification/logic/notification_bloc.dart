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
    // TODO: implement other logic
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event, 
    Emitter<NotificationState> emit
  ) async {
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
}

