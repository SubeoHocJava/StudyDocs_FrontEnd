class Notification {
  final String id;
  final String senderId;
  final String subject;
  final String body;
  bool isRead;
  final String type;
  final DateTime receivedAt;
  final DateTime? deletedAt;

  Notification({
    required this.id,
    required this.senderId,
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
      senderId: json['senderId'] ?? '',
      subject: json['subject'] ?? '',
      body: json['body'] ?? '',
      isRead: json['isRead'] ?? false,
      type: json['type'] ?? 'SYSTEM',
      receivedAt: json['receivedAt'] != null
          ? DateTime.tryParse(json['receivedAt']) ?? DateTime.now()
          : DateTime.now(),
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'])
          : null,
    );
  }
}
