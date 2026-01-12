
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';

class NotificationTemplateModel extends NotificationTemplateEntity {
  const NotificationTemplateModel({
    required super.id,
    required super.name,
    required super.channel,
    required super.description,
    required super.templateSubject,
    required super.templateBody,
    required super.type,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NotificationTemplateModel.fromJson(Map<String, dynamic> json) {
    return NotificationTemplateModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      channel: json['channel'] ?? '',
      description: json['description'] ?? '',
      templateSubject: json['templateSubject'] ?? '',
      templateBody: json['templateBody'] ?? '',
      type: json['type'] ?? 'LIKE', // Giá trị mặc định
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'channel': channel,
      'description': description,
      'templateSubject': templateSubject,
      'templateBody': templateBody,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
