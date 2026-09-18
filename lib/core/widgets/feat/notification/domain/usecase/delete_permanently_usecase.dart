import '../repository/notification_repository.dart';

abstract interface class DeletePermanentlyUseCase {
  Future<void> call(String id);
}

class DeletePermanentlyUseCaseImpl implements DeletePermanentlyUseCase {
  final NotificationRepository _notificationRepository;

  DeletePermanentlyUseCaseImpl(this._notificationRepository);

  @override
  Future<void> call(String id) async {
    return await _notificationRepository.deletePermanently(id);
  }
}
