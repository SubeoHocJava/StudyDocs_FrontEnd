import 'package:studydocs/features/notification/data/model/notification.dart';

// Đây là API mock trả dữ liệu mẫu trong giai đoạn phát triển.
// Khi tích hợp backend thật, triển khai các phương thức để gọi HTTP.
class NotificationApi {
  Future<void> markAsRead(String notificationId) async {}

  Future<List<AppNotification>> getNotifications(DateTime createdAt,bool isDeleted) async {
    return [
      AppNotification(
        id: "1",
        sender: "Hệ thống",
        subject: "Cập nhật phiên bản",
        content:
            "Ứng dụng đã được cập nhật lên phiên bản 2.1 với nhiều tính năng mới.",
        isRead: false,
        type: "like",
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      AppNotification(
        id: "2",
        sender: "Admin",
        subject: "Khuyến mãi đặc biệt",
        content: "Nhận ngay ưu đãi 50% cho đơn hàng đầu tiên trong hôm nay!",
        isRead: true,
        type: "download",
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: "3",
        sender: "Người dùng A",
        subject: "Tin nhắn mới",
        content: "Chào bạn, hôm nay bạn có rảnh không?",
        isRead: false,
        type: "message",
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      ),
      AppNotification(
        id: "4",
        sender: "Hệ thống",
        subject: "Bảo trì",
        content: "Dịch vụ sẽ được bảo trì vào 23:00 tối nay.",
        isRead: true,
        type: "system",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        deletedAt: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
      ),
      AppNotification(
        id: "5",
        sender: "Shop ABC",
        subject: "Đơn hàng của bạn",
        content:
            "Đơn hàng #12345 đã được giao thành công.Đơn hàng #12345 đã được giao thành công.Đơn hàng #12345 đã được giao thành công.",
        isRead: false,
        type: "order",
        createdAt: DateTime.now().subtract(const Duration(days: 5, hours: 6)),
      ),
    ];
  }

  Future<void> softDelete(String notificationId) async {}

  Future<void> hardDelete(String notificationId) async {}

  Future<void> markAllAsRead() async {}
}
