import 'package:studydocs/data/model/notification.dart';

class NotificationEntity {
  final String id;
  final String sender;
  final String subject;
  final String body;
  final bool isRead;
  final String type;
  final DateTime receivedAt;
  final DateTime? deletedAt;

  const NotificationEntity({
    required this.id,
    required this.sender,
    required this.subject,
    required this.body,
    required this.isRead,
    required this.type,
    required this.receivedAt,
    this.deletedAt,
  });

  /* ================= Derived State ================= */

  bool get isDeleted => deletedAt != null;

  /* ================= Domain Behaviors ================= */

  /// Đánh dấu đã đọc
  NotificationEntity read() {
    if (isRead) return this;
    return _copyWith(isRead: true);
  }

  /// Đánh dấu chưa đọc
  NotificationEntity unread() {
    if (!isRead) return this;
    return _copyWith(isRead: false);
  }

  /// Soft delete – mỗi lần gọi sẽ cập nhật deletedAt = now
  NotificationEntity delete() {
    return _copyWith(deletedAt: DateTime.now());
  }

  /// Khôi phục thông báo
  NotificationEntity restore() {
    if (!isDeleted) return this;
    return _copyWith(deletedAt: null, restore: true);
  }

  /* ================= Time Helpers ================= */

  String timeAgo() {
    final now = DateTime.now();
    final diff = now.difference(receivedAt);

    if (diff.inSeconds < 5) return "Vừa xong";
    if (diff.inSeconds < 60) return "${diff.inSeconds}s trước";
    if (diff.inMinutes < 60) return "${diff.inMinutes}p trước";
    if (diff.inHours < 24) return "${diff.inHours}h trước";
    return "${diff.inDays} ngày trước";
  }

  String formattedCreatedTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final createdDay = DateTime(
      receivedAt.year,
      receivedAt.month,
      receivedAt.day,
    );
    final yesterday = today.subtract(const Duration(days: 1));

    if (createdDay == today) return timeAgo();
    if (createdDay == yesterday) return "Hôm qua";

    return "${receivedAt.day.toString().padLeft(2, '0')}/"
        "${receivedAt.month.toString().padLeft(2, '0')}/"
        "${receivedAt.year}";
  }

  String formattedDeletedTime() {
    if (deletedAt == null) return '';
    return "${deletedAt!.day.toString().padLeft(2, '0')}/"
        "${deletedAt!.month.toString().padLeft(2, '0')}/"
        "${deletedAt!.year}";
  }

  /* ================= Internal Copy ================= */

  NotificationEntity _copyWith({
    bool? isRead,
    DateTime? deletedAt,
    bool? restore,
  }) {
    return NotificationEntity(
      id: id,
      sender: sender,
      subject: subject,
      body: body,
      isRead: isRead ?? this.isRead,
      type: type,
      receivedAt: receivedAt,
      deletedAt: restore ?? false ? null : deletedAt ?? this.deletedAt,
    );
  }

  /* ================= Factory ================= */

  static NotificationEntity fromModel(Notification model) {
    return NotificationEntity(
      id: model.id,
      sender: model.senderId,
      subject: model.subject,
      body: model.body,
      isRead: model.isRead,
      type: model.type,
      receivedAt: model.receivedAt,
      deletedAt: model.deletedAt,
    );
  }
}
