class NotificationTemplateEntity {
  final String id;
  final String name;
  final String channel;
  final String description;
  final String templateSubject;
  final String templateBody;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationTemplateEntity({
    required this.id,
    required this.name,
    required this.channel,
    required this.description,
    required this.templateSubject,
    required this.templateBody,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NotificationTemplateEntity &&
      other.id == id &&
      other.name == name &&
      other.channel == channel &&
      other.description == description &&
      other.templateSubject == templateSubject &&
      other.templateBody == templateBody &&
      other.type == type &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      channel.hashCode ^
      description.hashCode ^
      templateSubject.hashCode ^
      templateBody.hashCode ^
      type.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
