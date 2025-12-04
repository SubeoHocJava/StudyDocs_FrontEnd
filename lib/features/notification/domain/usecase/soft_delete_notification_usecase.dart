import 'package:studydocs/features/notification/domain/repository/impl/notification_repository.dart';

/// UseCase: Chuyển notification vào thùng rác (soft delete)
class SoftDeleteNotificationParams {
  final String notificationId;

  SoftDeleteNotificationParams(this.notificationId);
}

class SoftDeleteNotificationUseCase {
  final NotificationRepositoryImpl repository;

  SoftDeleteNotificationUseCase(this.repository);

  Future<void> call(SoftDeleteNotificationParams params) async {
    await repository.softDelete(params.notificationId);
  }
}
