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

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? '',
      sender: json['senderName'] ?? '',
      subject: json['subject'] ?? '',
      body: json['body'] ?? '',
      isRead: json['isRead'] ?? false,
      type: json['type'] ?? 'SYSTEM',
      receivedAt: json['receivedAt'] != null
          ? DateTime.parse(json['receivedAt'])
          : DateTime.now(),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}
