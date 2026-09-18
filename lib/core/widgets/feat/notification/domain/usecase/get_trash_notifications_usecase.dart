import 'package:studydocs/data/model/notification_model.dart';
import '../repository/notification_repository.dart';

abstract interface class GetTrashNotificationsUseCase {
  Future<List<NotificationModel>> call();
}

class GetTrashNotificationsUseCaseImpl implements GetTrashNotificationsUseCase {
  final NotificationRepository _notificationRepository;

  GetTrashNotificationsUseCaseImpl(this._notificationRepository);

  @override
  Future<List<NotificationModel>> call() async {
    return await _notificationRepository.getTrashNotifications();
  }
}
