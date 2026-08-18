import 'package:equatable/equatable.dart';

enum NotificationType {
  like,
  comment,
  download,
  save,
  system, // Future-proof
}

class NotificationModel extends Equatable {
  final String id;
  final String avatarUrl; // User who triggered the noti
  final String title;
  final String content;
  final DateTime receivedAt;
  final DateTime? deletedAt;
  final NotificationType type;
  final bool isRead;
  final bool isDeleted;

  const NotificationModel({
    required this.id,
    required this.avatarUrl,
    required this.title,
    required this.content,
    required this.receivedAt,
    required this.type,
    this.isRead = false,
    this.isDeleted = false,
    this.deletedAt,
  });

  NotificationModel copyWith({
    String? id,
    String? avatarUrl,
    String? title,
    String? content,
    DateTime? receivedAt,
    NotificationType? type,
    bool? isRead,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      title: title ?? this.title,
      content: content ?? this.content,
      receivedAt: receivedAt ?? this.receivedAt,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  List<Object?> get props => [id, avatarUrl, title, content, receivedAt, type, isRead, isDeleted, deletedAt];
}
