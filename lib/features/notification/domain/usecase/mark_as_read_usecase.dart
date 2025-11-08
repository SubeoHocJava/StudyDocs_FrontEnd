import 'package:studydocs/features/notification/data/repository/notification_repository.dart';

/// UseCase: Đánh dấu một notification là đã đọc
class MarkAsReadParams {
  final String notificationId;

  MarkAsReadParams(this.notificationId);
}

class MarkAsReadUseCase {
  final NotificationRepository repository;

  MarkAsReadUseCase(this.repository);

  Future<void> call(MarkAsReadParams params) async {
    await repository.markAsRead(params.notificationId);
  }
}
