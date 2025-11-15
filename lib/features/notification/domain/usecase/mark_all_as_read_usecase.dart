import 'package:studydocs/features/notification/domain/repository/impl/notification_repository.dart';

/// UseCase: Đánh dấu tất cả notification là đã đọc
class MarkAllAsReadUseCase {
  final NotificationRepositoryImpl repository;

  MarkAllAsReadUseCase(this.repository);

  Future<void> call() async {
    await repository.markAllAsRead();
  }
}
