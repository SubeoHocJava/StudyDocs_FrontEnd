import 'package:studydocs/features/notification/data/model/notification.dart';
import 'package:studydocs/features/notification/domain/api/notification_api.dart';


// Repository làm nhiệm vụ tách rời tầng dữ liệu khỏi BLoC/UI.
// - Gọi NotificationApi để lấy/cập nhật/xóa dữ liệu
// - Không xử lý lỗi cục bộ (để BLoC có thể quyết định hành vi hiển thị lỗi)
class NotificationRepository {
  final NotificationApi _notificationApi;

  NotificationRepository(this._notificationApi);

  Future<List<AppNotification>> getNotifications(
    DateTime createAt,
    bool isDeleted,
  ) async {
    // Lấy danh sách notification từ API. Không swallow error ở đây để
    // tầng BLoC có thể xử lý lỗi (emit NotificationErrorState).
    return await _notificationApi.getNotifications(createAt, isDeleted);
  }

  //update
  Future<void> markAsRead(String notificationId) async {
    // Gọi API đánh dấu đã đọc; lỗi được bubble lên caller nếu cần.
    await _notificationApi.markAsRead(notificationId);
  }

  Future<void> markAllAsRead() async {
    await _notificationApi.markAllAsRead();
  }

  //delete
  Future<void> softDelete(String notificationId) async {
    await _notificationApi.softDelete(notificationId);
  }

  Future<void> hardDelete(String notificationId) async {
    await _notificationApi.hardDelete(notificationId);
  }
}
