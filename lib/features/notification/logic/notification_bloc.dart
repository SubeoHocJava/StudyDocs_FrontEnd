import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/notification/domain/repository/impl/notification_repository.dart';
import 'package:studydocs/features/notification/domain/usecase/get_notifications_usecase.dart';
import 'package:studydocs/features/notification/domain/usecase/mark_as_read_usecase.dart';
import 'package:studydocs/features/notification/domain/usecase/mark_all_as_read_usecase.dart';
import 'package:studydocs/features/notification/domain/usecase/soft_delete_notification_usecase.dart';
import 'package:studydocs/features/notification/domain/usecase/hard_delete_notification_usecase.dart';
import 'package:studydocs/features/notification/logic/notification_state.dart';
import 'package:studydocs/features/notification/logic/notification_event.dart';

// BLoC xử lý toàn bộ luồng nghiệp vụ liên quan đến thông báo:
// load danh sách, đánh dấu đã đọc, đánh dấu tất cả đã đọc, xóa mềm/xóa cứng.
// Nhận Event từ UI, gọi repository thông qua usecase và emit State tương ứng.
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepositoryImpl repository;

  NotificationBloc(this.repository) : super(NotificationInitialState()) {

    // Khởi tạo các usecase sử dụng chung repository.
    // Mọi logic xử lý trong BLoC đều đi qua tầng domain.
    final getNotificationsUseCase = GetNotificationsUseCase(repository);
    final markAsReadUseCase = MarkAsReadUseCase(repository);
    final markAllAsReadUseCase = MarkAllAsReadUseCase(repository);
    final softDeleteUseCase = SoftDeleteNotificationUseCase(repository);
    final hardDeleteUseCase = HardDeleteNotificationUseCase(repository);

    // Load danh sách thông báo
    on<LoadNotificationEvent>((event, emit) async {
      emit(NotificationLoadingState());
      try {
        final notifications = await getNotificationsUseCase(
          GetNotificationsParams(
            createAt: event.createdAt,
            isDeleted: event.isDeleted,
          ),
        );
        emit(NotificationLoadedState(notifications));
      } catch (e) {
        emit(NotificationErrorState(e.toString()));
      }
    });

    // Đánh dấu 1 thông báo đã đọc
    // Sau khi API thành công thì cập nhật lại danh sách hiện tại
    on<MarkAsReadEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        try {
          await markAsReadUseCase(MarkAsReadParams(event.notificationId));

          final updatedList = currentState.notifications.map((n) {
            return n.id == event.notificationId
                ? n.copyWith(isRead: true)
                : n;
          }).toList();

          emit(NotificationLoadedState(updatedList));
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

          final updatedList = currentState.notifications.map((n) {
            return n.isRead ? n : n.copyWith(isRead: true);
          }).toList();

          emit(NotificationLoadedState(updatedList));
        } catch (e) {
          emit(NotificationErrorState(e.toString()));
        }
      }
    });

    // Xóa thông báo: soft delete hoặc hard delete
    // Sau khi API thành công thì loại bỏ item khỏi danh sách hiện tại
    on<DeleteNotificationEvent>((event, emit) async {
      if (state is NotificationLoadedState) {
        final currentState = state as NotificationLoadedState;
        try {
          if (event.type == DeleteType.hard) {
            await hardDeleteUseCase(HardDeleteNotificationParams(event.notificationId));
          } else {
            await softDeleteUseCase(SoftDeleteNotificationParams(event.notificationId));
          }

          final updatedList = currentState.notifications
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
