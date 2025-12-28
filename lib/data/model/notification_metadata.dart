class NotificationMetadata {
  final String groupName;
  final Map<String, String> items;

  NotificationMetadata({
    required this.groupName,
    required this.items,
  });

  factory NotificationMetadata.fromJson(Map<String, dynamic> json) {
    return NotificationMetadata(
      groupName: json['groupName'] as String,
      items: Map<String, String>.from(json['items'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'items': items,
    };
  }
}
