import 'package:studydocs/data/datasource/notification_remote_datasource.dart';
import 'package:studydocs/data/model/notification_metadata.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/domain/entity/paginated_result.dart';
import 'package:studydocs/features/notification/domain/repository/notification_repository.dart';

// Repository làm nhiệm vụ tách rời tầng dữ liệu khỏi BLoC/UI.
// - Gọi NotificationApi để lấy/cập nhật/xóa dữ liệu
// - Không xử lý lỗi cục bộ (để BLoC có thể quyết định hành vi hiển thị lỗi)
class NotificationRepositoryImpl implements NotificationRepository{
  final NotificationDataSource notificationDataSource;

  NotificationRepositoryImpl(this.notificationDataSource);

  @override
  Future<PaginatedResult<NotificationEntity>> getNotifications(
    dynamic cursor,
    bool isDeleted,
  ) async {
    final result = await notificationDataSource.getNotifications(cursor, isDeleted);
    return PaginatedResult(
      data: result.data.map((e) => NotificationEntity.fromModel(e)).toList(),
      nextCursor: result.nextCursor,
      total: result.total,
      hasNext: result.hasNext,
    );
  }

  @override
  Future<int> getUnreadCount() async {
    return await notificationDataSource.getUnreadCount();
  }

  //update
  @override
  Future<void> markAsRead(String notificationId) async {
    await notificationDataSource.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead() async {
    await notificationDataSource.markAllAsRead();
  }

  //delete
  @override
  Future<void> softDelete(List<String> notificationIds) async {
    await notificationDataSource.softDelete(notificationIds);
  }
  @override
  Future<void> hardDelete(List<String> notificationIds) async {
    await notificationDataSource.hardDelete(notificationIds);
  }

  @override
  Future<void> restore(List<String> notificationIds) async {
    await notificationDataSource.restore(notificationIds);
  }

  @override
  Future<List<NotificationMetadata>> getMetadata() async {
    return await notificationDataSource.getMetadata();
  }

  @override
  Future<void> registerFcmToken(String token) async {
    await notificationDataSource.registerFcmToken(token);
  }
}
