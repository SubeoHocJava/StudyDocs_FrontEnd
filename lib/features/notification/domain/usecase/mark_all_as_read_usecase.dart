import 'package:studydocs/features/notification/data/repository/notification_repository.dart';

/// UseCase: Đánh dấu tất cả notification là đã đọc
class MarkAllAsReadUseCase {
  final NotificationRepository repository;

  MarkAllAsReadUseCase(this.repository);

  Future<void> call() async {
    await repository.markAllAsRead();
  }
}
