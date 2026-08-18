import 'package:studydocs/core/feat/notification/domain/entity/notification_model.dart';
import 'package:studydocs/core/feat/notification/domain/repository/notification_repository.dart';

class MockNotificationRepository implements NotificationRepository {
  List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      avatarUrl: '',
      title: 'Ngọc Thiện',
      content: 'và 15 người khác đã thích tài liệu của bạn: Tài liệu hướng dẫn sử dụng phần mềm Flutter cho người mới bắt đầu.',
      receivedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      type: NotificationType.like,
      isRead: true,
    ),
    NotificationModel(
      id: '2',
      avatarUrl: '',
      title: 'Minh Hiển',
      content: 'và 3 người khác đã thích tải liệu của bạn: Đồ án Chuyên ngành môn Lập trình ứng dụng di động nâng cao.',
      receivedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      type: NotificationType.download,
      isRead: true,
    ),
    NotificationModel(
      id: '3',
      avatarUrl: '',
      title: 'Văn Hào',
      content: 'đã lưu tải liệu của bạn: Slide Chương 6 Lập trình mạng RMI và ứng dụng phân tán.',
      receivedAt: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotificationType.save,
      isRead: true,
    ),
    NotificationModel(
      id: '4',
      avatarUrl: '',
      title: 'Tuấn Dũng',
      content: 'đã bình luận về tài liệu của bạn: Cho mình xin thêm chương mới về phần socket của môn này được không bạn ơi?',
      receivedAt: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotificationType.comment,
      isRead: false,
    ),
  ];

  List<NotificationModel> _trash = [
    NotificationModel(
      id: '5',
      avatarUrl: '',
      title: 'Ngọc Thiện',
      content: 'và 15 người khác đã thích tài liệu của bạn: Tài liệu hướng dẫn sử dụng...',
      receivedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      deletedAt: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.like,
      isRead: true,
      isDeleted: true,
    ),
  ];

  @override
  Future<List<NotificationModel>> getNotifications() async => List.from(_notifications);

  @override
  Future<List<NotificationModel>> getTrashNotifications() async => List.from(_trash);

  @override
  Future<void> markAsRead(String id) async {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) _notifications[idx] = _notifications[idx].copyWith(isRead: true);
  }

  @override
  Future<void> moveToTrash(String id) async {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      final note = _notifications.removeAt(idx);
      _trash.add(note.copyWith(isDeleted: true, deletedAt: DateTime.now()));
    }
  }

  @override
  Future<void> restoreFromTrash(String id) async {
    final idx = _trash.indexWhere((n) => n.id == id);
    if (idx != -1) {
      final note = _trash.removeAt(idx);
      _notifications.add(note.copyWith(isDeleted: false, deletedAt: null));
    }
  }

  @override
  Future<void> deletePermanently(String id) async {
    _trash.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
  }

  @override
  Future<void> deleteAllPermanently() async {
    _trash.clear();
  }

  @override
  Future<void> restoreAllFromTrash() async {
    _notifications.addAll(_trash.map((n) => n.copyWith(isDeleted: false, deletedAt: null)));
    _trash.clear();
  }

  @override
  Future<void> moveToTarget(String id, String targetId) async {}
}
