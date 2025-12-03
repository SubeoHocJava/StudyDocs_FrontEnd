class Notification {
  final String id;
  final String sender;
  final String subject;
  final String body;
  bool isRead;
  final String type;
  final DateTime receivedAt;
  final DateTime? deletedAt;

  Notification({
    required this.id,
    required this.sender,
    required this.subject,
    required this.body,
    this.isRead = false,
    required this.type,
    required this.receivedAt,
    this.deletedAt,
  });
}
