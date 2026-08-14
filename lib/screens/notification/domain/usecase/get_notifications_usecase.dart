import '../entity/notification_model.dart';
import '../repository/notification_repository.dart';

abstract interface class GetNotificationsUseCase {
  Future<List<NotificationModel>> call();
}

class GetNotificationsUseCaseImpl implements GetNotificationsUseCase {
  final NotificationRepository _notificationRepository;

  GetNotificationsUseCaseImpl(this._notificationRepository);

  @override
  Future<List<NotificationModel>> call() async {
    return await _notificationRepository.getNotifications();
  }
}
