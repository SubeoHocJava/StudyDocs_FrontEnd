import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification/data/notification_repository.dart';
import 'package:studydocs/features/notification/logic/notification_state.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(NotificationInitialState()) {
    /// Load notification
    on<LoadNotificationEvent>((event, emit) async {
      emit(NotificationLoadingState());
      try {
        final notifications = await repository.getNotifications(
          event.createdAt,
          event.isDeleted,
        );
        emit(NotificationLoadedState(notifications));
      } catch (e) {
        emit(NotificationErrorState(e.toString()));
      }
    });

    /// Mark as read
    on<MarkAsReadEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        try {
          await repository.markAsRead(event.notificationId);
          final updatedList =
              currentState.notifications.map((n) {
                if (n.id == event.notificationId) {
                  return n.copyWith(isRead: true);
                }
                return n;
              }).toList();
          emit(NotificationLoadedState(updatedList));
        } catch (e) {
          emit(NotificationErrorState(e.toString()));
        }
      }
    });

    /// Mark all as read
    on<MarkAllAsReadEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        try {
          await repository.markAllAsRead();
          final updatedList =
              currentState.notifications.map((n) {
                if (n.isRead) {
                  return n;
                }
                return n.copyWith(isRead: true);
              }).toList();
          emit(NotificationLoadedState(updatedList));
        } catch (e) {
          emit(NotificationErrorState(e.toString()));
        }
      }
    });

    /// Delete
    on<DeleteNotificationEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        try {
          if (event.type == DeleteType.hard) {
            await repository.hardDelete(event.notificationId);
          } else {
            await repository.softDelete(event.notificationId);
          }
          final updatedList =
              currentState.notifications
                  .where((n) => n.id != event.notificationId)
                  .toList();
          emit(NotificationLoadedState(updatedList));
        } catch (e) {
          emit(NotificationErrorState(e.toString()));
        }
      }
    });
  }
}
