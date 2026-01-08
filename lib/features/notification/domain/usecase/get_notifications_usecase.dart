import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/domain/entity/paginated_result.dart';
import 'package:studydocs/features/notification/domain/repository/notification_repository.dart';

/// UseCase: Lấy danh sách notification
/// Input: [GetNotificationsParams] chứa cursor và isDeleted flag
/// Output: Future`<PaginatedResult<NotificationEntity>>`
class GetNotificationsParams {
  final dynamic cursor;
  final bool isDeleted;

  GetNotificationsParams({this.cursor, required this.isDeleted});
}

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<PaginatedResult<NotificationEntity>> call(GetNotificationsParams params) async {
    return await repository.getNotifications(params.cursor, params.isDeleted);
  }
}
