class Notification {
  final String id;
  final String sender;
  final String subject;
  final String content;
  bool isRead;
  final String type;
  final DateTime createdAt;
  final DateTime? deletedAt;

  Notification({
    required this.id,
    required this.sender,
    required this.subject,
    required this.content,
    this.isRead = false,
    required this.type,
    required this.createdAt,
    this.deletedAt,
  });
}
