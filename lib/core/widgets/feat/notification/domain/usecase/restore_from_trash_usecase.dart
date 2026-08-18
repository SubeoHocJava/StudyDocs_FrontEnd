import '../repository/notification_repository.dart';

abstract interface class RestoreFromTrashUseCase {
  Future<void> call(String id);
}

class RestoreFromTrashUseCaseImpl implements RestoreFromTrashUseCase {
  final NotificationRepository _notificationRepository;

  RestoreFromTrashUseCaseImpl(this._notificationRepository);

  @override
  Future<void> call(String id) async {
    return await _notificationRepository.restoreFromTrash(id);
  }
}
