
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';
import 'package:studydocs/features/notification_template/data/model/category_model.dart';
import 'package:studydocs/features/notification_template/data/model/channel_model.dart';

class NotificationTemplateModel extends NotificationTemplateEntity {
  const NotificationTemplateModel({
    required super.id,
    required super.name,
    required super.channel,
    required super.description,
    required super.templateSubject,
    required super.templateBody,
    required super.category,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NotificationTemplateModel.fromJson(Map<String, dynamic> json) {
    return NotificationTemplateModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      channel: json['channel'] != null
          ? ChannelModel.fromJson(json['channel'])
          : const ChannelModel(code: '', name: ''),
      description: json['description'] ?? '',
      templateSubject: json['templateSubject'] ?? '',
      templateBody: json['templateBody'] ?? '',
      category: json['type'] != null
          ? CategoryModel(code: json['type'], name: '')
          : const CategoryModel(code: 'LIKE', name: ''),
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
      'type': category.code,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
