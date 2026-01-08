import 'package:studydocs/features/notification/domain/repository/notification_repository.dart';

class RestoreNotificationsParams {
  final List<String> notificationIds;

  RestoreNotificationsParams(this.notificationIds);
}

class RestoreNotificationsUseCase {
  final NotificationRepository repository;

  RestoreNotificationsUseCase(this.repository);

  Future<void> call(RestoreNotificationsParams params) async {
    await repository.restore(params.notificationIds);
  }
}
