import 'package:studydocs/features/notification/domain/repository/notification_repository.dart';

/// UseCase: Chuyển notification vào thùng rác (soft delete)
class SoftDeleteNotificationParams {
  final List<String> notificationIds;

  SoftDeleteNotificationParams(this.notificationIds);
}

class SoftDeleteNotificationUseCase {
  final NotificationRepository repository;

  SoftDeleteNotificationUseCase(this.repository);

  Future<void> call(SoftDeleteNotificationParams params) async {
    await repository.softDelete(params.notificationIds);
  }
}
