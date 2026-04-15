import '../repository/notification_repository.dart';

abstract interface class MarkAsReadUseCase {
  Future<void> call(String id);
}

class MarkAsReadUseCaseImpl implements MarkAsReadUseCase {
  final NotificationRepository _notificationRepository;

  MarkAsReadUseCaseImpl(this._notificationRepository);

  @override
  Future<void> call(String id) async {
    return await _notificationRepository.markAsRead(id);
  }
}
