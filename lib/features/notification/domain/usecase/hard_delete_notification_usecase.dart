import 'package:studydocs/features/notification/data/repository/notification_repository.dart';

/// UseCase: Xóa vĩnh viễn notification (hard delete)
class HardDeleteNotificationParams {
  final String notificationId;

  HardDeleteNotificationParams(this.notificationId);
}

class HardDeleteNotificationUseCase {
  final NotificationRepository repository;

  HardDeleteNotificationUseCase(this.repository);

  Future<void> call(HardDeleteNotificationParams params) async {
    await repository.hardDelete(params.notificationId);
  }
}
