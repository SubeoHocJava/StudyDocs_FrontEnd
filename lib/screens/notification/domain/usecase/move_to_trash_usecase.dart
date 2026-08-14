import '../repository/notification_repository.dart';

abstract interface class MoveToTrashUseCase {
  Future<void> call(String id);
}

class MoveToTrashUseCaseImpl implements MoveToTrashUseCase {
  final NotificationRepository _notificationRepository;

  MoveToTrashUseCaseImpl(this._notificationRepository);

  @override
  Future<void> call(String id) async {
    return await _notificationRepository.moveToTrash(id);
  }
}
