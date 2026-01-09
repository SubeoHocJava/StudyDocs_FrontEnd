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
      id: json['id'] as String,
      name: json['name'] as String,
      channel: json['channel'] as String? ?? '',
      description: json['description'] as String? ?? '',
      templateSubject: json['templateSubject'] as String? ?? '',
      templateBody: json['templateBody'] as String? ?? '',
      type: json['type'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
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
