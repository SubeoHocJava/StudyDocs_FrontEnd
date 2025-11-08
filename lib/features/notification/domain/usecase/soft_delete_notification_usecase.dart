import 'package:studydocs/features/notification/data/repository/notification_repository.dart';

/// UseCase: Chuyển notification vào thùng rác (soft delete)
class SoftDeleteNotificationParams {
  final String notificationId;

  SoftDeleteNotificationParams(this.notificationId);
}

class SoftDeleteNotificationUseCase {
  final NotificationRepository repository;

  SoftDeleteNotificationUseCase(this.repository);

  Future<void> call(SoftDeleteNotificationParams params) async {
    await repository.softDelete(params.notificationId);
  }
}
