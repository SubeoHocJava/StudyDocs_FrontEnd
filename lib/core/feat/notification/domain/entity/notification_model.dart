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
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final bool isDeleted;

  const NotificationModel({
    required this.id,
    required this.avatarUrl,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.isDeleted = false,
  });

  NotificationModel copyWith({
    String? id,
    String? avatarUrl,
    String? title,
    String? content,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    bool? isDeleted,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [id, avatarUrl, title, content, timestamp, type, isRead, isDeleted];
}
