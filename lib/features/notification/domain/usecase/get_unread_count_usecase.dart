import 'package:studydocs/features/notification/domain/repository/notification_repository.dart';

class GetUnreadCountUseCase {
  final NotificationRepository repository;

  GetUnreadCountUseCase(this.repository);

  Future<int> call() async {
    return await repository.getUnreadCount();
  }
}
