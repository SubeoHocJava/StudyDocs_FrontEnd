import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/domain/repository/impl/notification_repository.dart';

/// UseCase: Lấy danh sách notification
/// Input: [GetNotificationsParams] chứa thời gian tạo và isDeleted flag
/// Output: Future`<List<NotificationEntity>>`
class GetNotificationsParams {
  final DateTime createAt;
  final bool isDeleted;

  GetNotificationsParams({required this.createAt, required this.isDeleted});
}

class GetNotificationsUseCase {
  final NotificationRepositoryImpl repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call(GetNotificationsParams params) async {
    return await repository.getNotifications(params.createAt, params.isDeleted).then((value) => value.map((e) => NotificationEntity.fromModel(e)).toList());
  }
}
