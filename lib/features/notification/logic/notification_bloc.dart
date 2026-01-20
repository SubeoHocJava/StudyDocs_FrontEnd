import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/error/error_mapper.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
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
          final newDeleted =
              isLoadMore
                  ? currentDeleted + paginatedResult.data
                  : paginatedResult.data;
          emit(
            NotificationLoadedState(
              currentActive,
              deletedNotifications: newDeleted,
              nextCursor: paginatedResult.nextCursor,
              hasNext: paginatedResult.hasNext,
            ),
          );
        } else {
          final unreadCount = await getUnreadCountUseCase();
          final newActive =
              isLoadMore
                  ? currentActive + paginatedResult.data
                  : paginatedResult.data;
          emit(
            NotificationLoadedState(
              newActive,
              deletedNotifications: currentDeleted,
              unreadCount: unreadCount,
              nextCursor: paginatedResult.nextCursor,
              hasNext: paginatedResult.hasNext,
            ),
          );
        }
      } catch (e) {
        emit(NotificationErrorState(_getErrorMessage(e)));
      }
    });

    on<GetUnreadCountEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        try {
          final unreadCount = await getUnreadCountUseCase();
          emit(currentState.copyWith(unreadCount: unreadCount));
        } catch (e) {
          emit(NotificationErrorState(_getErrorMessage(e)));
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
              return n.read();
            }
            return n;
          }).toList();

          // Update Deleted List (in case the item is in trash)
          final updatedDeleted = currentState.deletedNotifications.map((n) {
            if (n.id == event.notificationId && !n.isRead) {
              return n.read();
            }
            return n;
          }).toList();

          final newUnreadCount =
              currentState.unreadCount + unreadCountAdjustment;

          emit(
            currentState.copyWith(
              activeNotifications: updatedActive,
              deletedNotifications: updatedDeleted,
              unreadCount: newUnreadCount < 0 ? 0 : newUnreadCount,
            ),
          );
        } catch (e) {
          emit(NotificationErrorState(_getErrorMessage(e)));
        }
      }
    });

    // Đánh dấu tất cả thông báo đã đọc
    on<MarkAllAsReadEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        try {
          await markAllAsReadUseCase();

          final updatedActive =
              currentState.activeNotifications.map((n) {
                return n.read();
              }).toList();

          emit(
            currentState.copyWith(
              activeNotifications: updatedActive,
              unreadCount: 0,
            ),
          );
        } catch (e) {
          emit(NotificationErrorState(_getErrorMessage(e)));
        }
      }
    });

    // Xóa thông báo: soft delete hoặc hard delete
    on<DeleteNotificationEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        try {
          if (event.type == DeleteType.hard) {
            // ... (Hard delete logic remains same)
            await hardDeleteUseCase(
              HardDeleteNotificationParams(event.notificationIds),
            );

            final updatedDeleted =
                currentState.deletedNotifications
                    .where((n) => !event.notificationIds.contains(n.id))
                    .toList();

            emit(currentState.copyWith(deletedNotifications: updatedDeleted));
          } else {
            // === LOGIC XÓA MỀM (SOFT DELETE) ===
            // 1. Gọi API xóa mềm (cập nhật deletedAt trên server)
            await softDeleteUseCase(
              SoftDeleteNotificationParams(event.notificationIds),
            );

            // 2. Cập nhật UI ngay lập tức (Optimistic Update)
            // Thay vì chờ server trả về danh sách mới, ta tự chuyển item từ Active -> Deleted
            
            // Tìm các item cần xóa trong danh sách Active
            final toMove =
                currentState.activeNotifications
                    .where((n) => event.notificationIds.contains(n.id))
                    .map((n) => n.delete())
                    .toList();

            // Tạo danh sách Active mới (đã loại bỏ các item vừa xóa)
            final updatedActive =
                currentState.activeNotifications
                    .where((n) => !event.notificationIds.contains(n.id))
                    .toList();

            // Tạo danh sách Deleted mới (thêm các item vừa xóa vào đầu danh sách)
            final updatedDeleted = List<NotificationEntity>.from(
              currentState.deletedNotifications,
            )..insertAll(0, toMove);

            add(GetUnreadCountEvent());

            // 3. Emit state mới để báo hiệu cho UI render lại
            emit(
              currentState.copyWith(
                activeNotifications: updatedActive,
                deletedNotifications: updatedDeleted,
              ),
            );
          }
        } catch (e) {
          emit(NotificationErrorState(_getErrorMessage(e)));
        }
      }
    });

    on<DeleteAllLoadedNotificationEvent>((event, emit) async {
       // ... (Similar logic for Delete All)
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        if (currentState.activeNotifications.isEmpty) return;

        final ids = currentState.activeNotifications.map((e) => e.id).toList();
        try {
          await softDeleteUseCase(SoftDeleteNotificationParams(ids));

          final toMove = currentState.activeNotifications
              .map((n) => n.delete())
              .toList();

          final updatedDeleted = List<NotificationEntity>.from(
            currentState.deletedNotifications,
          )..insertAll(0, toMove);

          add(GetUnreadCountEvent());

          emit(
            currentState.copyWith(
              activeNotifications: [],
              deletedNotifications: updatedDeleted,
            ),
          );
        } catch (e) {
          emit(NotificationErrorState(_getErrorMessage(e)));
        }
      }
    });

    on<RestoreNotificationEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        // 1. Tính toán trạng thái mới dựa trên dữ liệu hiện có
        
        // a. Lấy các item cần khôi phục từ danh sách Deleted & xóa dấu mốc deletedAt
        final restored =
            currentState.deletedNotifications
                .where((n) => event.notificationIds.contains(n.id))
                .map((n) => n.restore())
                .toList();

        // b. Tạo danh sách Deleted mới (đã loại bỏ các item vừa được khôi phục)
        final updatedDeleted =
            currentState.deletedNotifications
                .where((n) => !event.notificationIds.contains(n.id))
                .toList();

        // c. Tạo danh sách Active mới (thêm các item vừa khôi phục vào đầu danh sách)
        final updatedActive = List<NotificationEntity>.from(
          currentState.activeNotifications,
        )..insertAll(0, restored);

        // 2. Emit state mới NGAY LẬP TỨC để UI cập nhật
        emit(
          currentState.copyWith(
            activeNotifications: updatedActive,
            deletedNotifications: updatedDeleted,
          ),
        );

        try {
          // 3. Gọi API thực hiện khôi phục ngầm (Background Sync)
          await restoreNotificationsUseCase(
            RestoreNotificationsParams(event.notificationIds),
          );
          
          // 4. Cập nhật lại số lượng chưa đọc (để đảm bảo chính xác với server)
          add(GetUnreadCountEvent());
        } catch (e) {
          // Ở đây ta báo lỗi và reload lại toàn bộ để đồng bộ lại dữ liệu chuẩn.
          emit(NotificationErrorState(_getErrorMessage(e)));
          add(const LoadNotificationEvent(isDeleted: true)); 
          add(const LoadNotificationEvent(isDeleted: false));
        }
      }
    });
  }

  String _getErrorMessage(Object error) {
    if (error is ApiException) {
      return ErrorMapper.map(int.tryParse(error.code ?? ''));
    }
    return ErrorMapper.map(500);
  }
}
