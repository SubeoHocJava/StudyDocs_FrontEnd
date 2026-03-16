import '../entity/notification_model.dart';
import '../repository/notification_repository.dart';

class MockNotificationRepositoryImpl implements NotificationRepository {
  List<NotificationModel> _active = [];
  List<NotificationModel> _trash = [];

  MockNotificationRepositoryImpl() {
    final now = DateTime.now();
    _active = [
      NotificationModel(
        id: '1', avatarUrl: 'assets/icons/avatar.png',
        title: 'Ngọc Thiện và 15 người khác đã thích tài liệu của bạn', content: 'Tài liệu hướng dẫn sử dụng...',
        receivedAt: now.subtract(const Duration(minutes: 2)), type: NotificationType.like, isRead: false,
      ),
      NotificationModel(
        id: '2', avatarUrl: 'assets/icons/avatar.png',
        title: 'Minh Hiển và 3 người khác đã tải tài liệu của bạn', content: 'Đồ án Chuyên ngành môn Lập trình...',
        receivedAt: now.subtract(const Duration(minutes: 10)), type: NotificationType.download, isRead: false,
      ),
      NotificationModel(
        id: '3', avatarUrl: 'assets/icons/avatar.png',
        title: 'Văn Hảo đã lưu tài liệu của bạn', content: 'Slide Chương 6...',
        receivedAt: now.subtract(const Duration(hours: 1)), type: NotificationType.save, isRead: true,
      ),
      NotificationModel(
        id: '4', avatarUrl: 'assets/icons/avatar.png',
        title: 'Tuấn Dũng đã bình luận về tài liệu của bạn', content: 'Cho mình xin thêm...',
        receivedAt: now.subtract(const Duration(hours: 1)), type: NotificationType.comment, isRead: true,
      ),
      NotificationModel(
        id: '5', avatarUrl: 'assets/icons/avatar.png',
        title: 'Lâm Bảo Duy và 4 người khác đã thích', content: 'Cách...',
        receivedAt: now.subtract(const Duration(hours: 5)), type: NotificationType.like, isRead: true,
      ),
      NotificationModel(
        id: '6', avatarUrl: 'assets/icons/avatar.png',
        title: 'Nhật Vy và 1 người khác đã thích tài liệu của bạn', content: 'Tài liệu hướng dẫn sử dụng...',
        receivedAt: now.subtract(const Duration(days: 2)), type: NotificationType.like, isRead: false,
      ),
      NotificationModel(
        id: '7', avatarUrl: 'assets/icons/avatar.png',
        title: 'Phương Mai và 3 người khác đã tải tài liệu của bạn', content: 'Đồ án Chuyên ngành môn Lập trình...',
        receivedAt: now.subtract(const Duration(days: 2, minutes: 10)), type: NotificationType.download, isRead: true,
      ),
    ];
    _trash = [
      NotificationModel(
        id: '10', avatarUrl: 'assets/icons/avatar.png',
        title: 'Ngọc Thiện và 15 người khác đã thích tài liệu của bạn', content: 'Tài liệu hướng dẫn sử dụng...',
        receivedAt: now.subtract(const Duration(days: 5)), type: NotificationType.like, isRead: true, isDeleted: true, deletedAt: now.subtract(const Duration(days: 1))
      ),
    ];
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _active;
  }

  @override
  Future<List<NotificationModel>> getTrashNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _trash;
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = _active.indexWhere((e) => e.id == id);
    if (index != -1) _active[index] = _active[index].copyWith(isRead: true);
  }

  @override
  Future<void> moveToTrash(String id) async {
    final item = _active.firstWhere((e) => e.id == id);
    _active.removeWhere((e) => e.id == id);
    _trash.add(item.copyWith(isDeleted: true, deletedAt: DateTime.now()));
  }

  @override
  Future<void> restoreFromTrash(String id) async {
    final item = _trash.firstWhere((e) => e.id == id);
    _trash.removeWhere((e) => e.id == id);
    _active.add(item.copyWith(isDeleted: false, deletedAt: null));
  }

  @override
  Future<void> deletePermanently(String id) async {
    _trash.removeWhere((e) => e.id == id);
  }

  @override
  Future<void> moveToTarget(String id, String targetId) async {}

  @override
  Future<void> markAllAsRead() async {
    _active = _active.map((e) => e.copyWith(isRead: true)).toList();
  }

  @override
  Future<void> deleteAllPermanently() async {
    _trash.clear();
  }

  @override
  Future<void> restoreAllFromTrash() async {
    _active.addAll(_trash.map((e) => e.copyWith(isDeleted: false, deletedAt: null)));
    _trash.clear();
  }
}
