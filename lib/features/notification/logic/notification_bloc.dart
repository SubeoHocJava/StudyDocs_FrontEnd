import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/domain/entity/paginated_result.dart';
import 'package:studydocs/features/notification/domain/repository/notification_repository.dart';
import 'package:studydocs/features/notification/domain/usecase/get_notifications_usecase.dart';
import 'package:studydocs/features/notification/domain/usecase/get_unread_count_usecase.dart';
import 'package:studydocs/features/notification/domain/usecase/hard_delete_notification_usecase.dart';
import 'package:studydocs/features/notification/domain/usecase/mark_all_as_read_usecase.dart';
import 'package:studydocs/features/notification/domain/usecase/mark_as_read_usecase.dart';
import 'package:studydocs/features/notification/domain/usecase/restore_notifications_usecase.dart';
import 'package:studydocs/features/notification/domain/usecase/soft_delete_notification_usecase.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';
import 'package:studydocs/features/notification/logic/notification_state.dart';

import 'notification_enum.dart';

// BLoC xử lý toàn bộ luồng nghiệp vụ liên quan đến thông báo:
// Nhận Event từ UI, gọi repository thông qua usecase và emit State tương ứng.
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(NotificationInitialState()) {

    // Khởi tạo các usecase.
    final getNotificationsUseCase = GetNotificationsUseCase(repository);
    final markAsReadUseCase = MarkAsReadUseCase(repository);
    final markAllAsReadUseCase = MarkAllAsReadUseCase(repository);
    final softDeleteUseCase = SoftDeleteNotificationUseCase(repository);
    final hardDeleteUseCase = HardDeleteNotificationUseCase(repository);
    final restoreNotificationsUseCase = RestoreNotificationsUseCase(repository);
    final getUnreadCountUseCase = GetUnreadCountUseCase(repository);

    // Load danh sách thông báo
    on<LoadNotificationEvent>((event, emit) async {
      final isLoadMore = event.cursor != null;

      // Keep previous lists
      List<NotificationEntity> currentActive = [];
      List<NotificationEntity> currentDeleted = [];

      if (state is NotificationLoadedState) {
        final s = state as NotificationLoadedState;
        currentActive = s.activeNotifications;
        currentDeleted = s.deletedNotifications;
      } else if (!isLoadMore) {
        emit(NotificationLoadingState());
      }

      try {
        final paginatedResult = await getNotificationsUseCase(
          GetNotificationsParams(
            cursor: event.cursor,
            isDeleted: event.isDeleted,
          ),
        );

        if (event.isDeleted) {
          final newDeleted = isLoadMore ? currentDeleted + paginatedResult.data : paginatedResult.data;
          emit(NotificationLoadedState(
            currentActive,
            deletedNotifications: newDeleted,
            nextCursor: paginatedResult.nextCursor,
            hasNext: paginatedResult.hasNext,
          ));
        } else {
          final unreadCount = await getUnreadCountUseCase();
          final newActive = isLoadMore ? currentActive + paginatedResult.data : paginatedResult.data;
          emit(NotificationLoadedState(
            newActive,
            deletedNotifications: currentDeleted,
            unreadCount: unreadCount,
            nextCursor: paginatedResult.nextCursor,
            hasNext: paginatedResult.hasNext,
          ));
        }
      } catch (e) {
        emit(NotificationErrorState(e.toString()));
      }
    });

    on<GetUnreadCountEvent>((event, emit) async {
       if (state is NotificationLoadedState) {
         final currentState = state as NotificationLoadedState;
         try {
           final unreadCount = await getUnreadCountUseCase();
           emit(currentState.copyWith(unreadCount: unreadCount));
         } catch (e) {
           emit(NotificationErrorState(e.toString()));
         }
       }
    });

    // Đánh dấu 1 thông báo đã đọc
    on<MarkAsReadEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        try {
          await markAsReadUseCase(MarkAsReadParams(event.notificationId));

          int unreadCountAdjustment = 0;
          final updatedActive = currentState.activeNotifications.map((n) {
            if (n.id == event.notificationId && !n.isRead) {
               unreadCountAdjustment = -1;
               return n.copyWith(isRead: true);
            }
            return n;
          }).toList();
          
          final newUnreadCount = currentState.unreadCount + unreadCountAdjustment;

          emit(currentState.copyWith(activeNotifications: updatedActive, unreadCount: newUnreadCount < 0 ? 0 : newUnreadCount));
        } catch (e) {
          emit(NotificationErrorState(e.toString()));
        }
      }
    });

    // Đánh dấu tất cả thông báo đã đọc
    on<MarkAllAsReadEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        try {
          await markAllAsReadUseCase();

          final updatedActive = currentState.activeNotifications.map((n) {
            return n.isRead ? n : n.copyWith(isRead: true);
          }).toList();

          emit(currentState.copyWith(activeNotifications: updatedActive, unreadCount: 0));
        } catch (e) {
          emit(NotificationErrorState(e.toString()));
        }
      }
    });

    // Xóa thông báo: soft delete hoặc hard delete
    on<DeleteNotificationEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        try {
          if (event.type == DeleteType.hard) {
            await hardDeleteUseCase(HardDeleteNotificationParams(event.notificationIds));

            final updatedDeleted = currentState.deletedNotifications
                .where((n) => !event.notificationIds.contains(n.id))
                .toList();

            emit(currentState.copyWith(deletedNotifications: updatedDeleted));
          } else {
            await softDeleteUseCase(SoftDeleteNotificationParams(event.notificationIds));

            // Move from active to deleted lists locally for immediate UI feedback
            final toMove = currentState.activeNotifications
                .where((n) => event.notificationIds.contains(n.id))
                .map((n) => n.copyWith(deletedAt: DateTime.now()))
                .toList();

            final updatedActive = currentState.activeNotifications
                .where((n) => !event.notificationIds.contains(n.id))
                .toList();

            final updatedDeleted = List<NotificationEntity>.from(currentState.deletedNotifications)
              ..insertAll(0, toMove);

            add(GetUnreadCountEvent());

            emit(currentState.copyWith(activeNotifications: updatedActive, deletedNotifications: updatedDeleted));
          }
        } catch (e) {
          emit(NotificationErrorState(e.toString()));
        }
      }
    });

    on<RestoreNotificationEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        try {
          await restoreNotificationsUseCase(RestoreNotificationsParams(event.notificationIds));

          // Remove from deleted and add back to active
          final restored = currentState.deletedNotifications
              .where((n) => event.notificationIds.contains(n.id))
              .map((n) => n.copyWith(deletedAt: null))
              .toList();

          final updatedDeleted = currentState.deletedNotifications
              .where((n) => !event.notificationIds.contains(n.id))
              .toList();

          final updatedActive = List<NotificationEntity>.from(currentState.activeNotifications)
            ..insertAll(0, restored);

          emit(currentState.copyWith(activeNotifications: updatedActive, deletedNotifications: updatedDeleted));

          add(GetUnreadCountEvent());
        } catch (e) {
           emit(NotificationErrorState(e.toString()));
        }
      }
    });
  }
}
