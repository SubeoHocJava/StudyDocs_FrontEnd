import 'package:studydocs/data/model/notification.dart';

class NotificationEntity {
  final String id;
  final String sender;
  final String subject;
  final String body;
  bool isRead;
  final String type;
  final DateTime receivedAt;
  final DateTime? deletedAt;

  NotificationEntity({
    required this.id,
    required this.sender,
    required this.subject,
    required this.body,
    this.isRead = false,
    required this.type,
    required this.receivedAt,
    this.deletedAt,
  });

  String timeAgo() {
    final now = DateTime.now();
    final diff = now.difference(receivedAt);

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
    final createdDay = DateTime(receivedAt.year, receivedAt.month, receivedAt.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (createdDay == today) {
      return timeAgo();
    } else if (createdDay == yesterday) {
      return "Hôm qua";
    } else {
      return "${receivedAt.day.toString().padLeft(2, '0')}/"
          "${receivedAt.month.toString().padLeft(2, '0')}/"
          "${receivedAt.year}";
    }
  }

  NotificationEntity copyWith({
    String? id,
    String? sender,
    String? subject,
    String? body,
    bool? isRead,
    String? type,
    DateTime? receivedAt,
    DateTime? deletedAt
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      receivedAt: receivedAt ?? this.receivedAt,
      deletedAt: deletedAt
    );
  }
  static NotificationEntity fromModel(Notification model){
    return  NotificationEntity(id: model.id, sender: model.sender, subject: model.subject, body: model.body, type: model.type, receivedAt: model.receivedAt);
  }

  String formatDeletedTime() {
    // Trả về ngày xóa theo format dd/MM/yyyy; nếu deletedAt null trả chuỗi rỗng
    if (deletedAt == null) return '';
    return "${deletedAt!.day.toString().padLeft(2, '0')}/${deletedAt!.month.toString().padLeft(2, '0')}/${deletedAt!.year}";
  }
}
