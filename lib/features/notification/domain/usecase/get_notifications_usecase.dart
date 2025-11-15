import 'package:studydocs/data/model/notification.dart';
import 'package:studydocs/features/notification/data/repository/notification_repository.dart';

/// UseCase: Lấy danh sách notification
/// Input: [GetNotificationsParams] chứa thời gian tạo và isDeleted flag
/// Output: Future`<List<AppNotification>>`
class GetNotificationsParams {
  final DateTime createAt;
  final bool isDeleted;

  GetNotificationsParams({required this.createAt, required this.isDeleted});
}

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<AppNotification>> call(GetNotificationsParams params) async {
    return await repository.getNotifications(params.createAt, params.isDeleted);
  }
}
