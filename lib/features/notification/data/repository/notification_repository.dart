import 'package:studydocs/data/datasource/notification_remote_source.dart';
import 'package:studydocs/data/model/notification.dart';


// Repository làm nhiệm vụ tách rời tầng dữ liệu khỏi BLoC/UI.
// - Gọi NotificationApi để lấy/cập nhật/xóa dữ liệu
// - Không xử lý lỗi cục bộ (để BLoC có thể quyết định hành vi hiển thị lỗi)
class NotificationRepository {
  final NotificationDataSource notificationDataSource;

  NotificationRepository(this.notificationDataSource);

  Future<List<AppNotification>> getNotifications(
    DateTime createAt,
    bool isDeleted,
  ) async {
    // Lấy danh sách notification từ API. Không swallow error ở đây để
    // tầng BLoC có thể xử lý lỗi (emit NotificationErrorState).
    return await notificationDataSource.getNotifications(createAt, isDeleted);
  }

  //update
  Future<void> markAsRead(String notificationId) async {
    // Gọi API đánh dấu đã đọc; lỗi được bubble lên caller nếu cần.
    await notificationDataSource.markAsRead(notificationId);
  }

  Future<void> markAllAsRead() async {
    await notificationDataSource.markAllAsRead();
  }

  //delete
  Future<void> softDelete(String notificationId) async {
    await notificationDataSource.softDelete(notificationId);
  }

  Future<void> hardDelete(String notificationId) async {
    await notificationDataSource.hardDelete(notificationId);
  }
}
