import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/domain/entity/paginated_result.dart';
import 'package:studydocs/data/model/notification_metadata.dart';

abstract interface class NotificationRepository {
  Future<PaginatedResult<NotificationEntity>> getNotifications(
    dynamic cursor,
    bool isDeleted,
  );

  Future<int> getUnreadCount();

  Future<void> markAsRead(String notificationId);

  Future<void> markAllAsRead();

  Future<void> softDelete(List<String> notificationId);

  Future<void> hardDelete(List<String> notificationId);

  Future<void> restore(List<String> notificationIds);

  Future<List<NotificationMetadata>> getMetadata();

  Future<void> registerFcmToken(String token);
}
