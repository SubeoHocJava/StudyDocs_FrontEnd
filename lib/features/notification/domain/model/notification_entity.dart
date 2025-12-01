import 'package:studydocs/data/model/notification.dart';

class NotificationEntity {
  final String id;
  final String sender;
  final String subject;
  final String content;
  bool isRead;
  final String type;
  final DateTime createdAt;
  final DateTime? deletedAt;

  NotificationEntity({
    required this.id,
    required this.sender,
    required this.subject,
    required this.content,
    this.isRead = false,
    required this.type,
    required this.createdAt,
    this.deletedAt,
  });

  String timeAgo() {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inSeconds < 5) {
      return "Vừa xong";
    } else if (diff.inSeconds < 60) {
      return "${diff.inSeconds}s trước";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes}p trước";
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h trước";
    } else {
      return "${diff.inDays} ngày trước";
    }
  }

  String formattedCreatedTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final createdDay = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (createdDay == today) {
      return timeAgo();
    } else if (createdDay == yesterday) {
      return "Hôm qua";
    } else {
      return "${createdAt.day.toString().padLeft(2, '0')}/"
          "${createdAt.month.toString().padLeft(2, '0')}/"
          "${createdAt.year}";
    }
  }

  NotificationEntity copyWith({
    String? id,
    String? sender,
    String? subject,
    String? content,
    bool? isRead,
    String? type,
    DateTime? createdAt,
    DateTime? deletedAt
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt
    );
  }
  static NotificationEntity fromModel(Notification model){
    return  NotificationEntity(id: model.id, sender: model.sender, subject: model.subject, content: model.content, type: model.type, createdAt: model.createdAt);
  }

  String formatDeletedTime() {
    // Trả về ngày xóa theo format dd/MM/yyyy; nếu deletedAt null trả chuỗi rỗng
    if (deletedAt == null) return '';
    return "${deletedAt!.day.toString().padLeft(2, '0')}/${deletedAt!.month.toString().padLeft(2, '0')}/${deletedAt!.year}";
  }
}
