import 'package:equatable/equatable.dart';
import 'package:studydocs/features/notification_template/domain/entity/category_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/channel_entity.dart';

class NotificationTemplateRequest extends Equatable {
  final String name;
  final ChannelEntity channel;
  final String description;
  final String templateSubject;
  final String templateBody;
  final CategoryEntity category;

  const NotificationTemplateRequest({
    required this.name,
    required this.channel,
    required this.description,
    required this.templateSubject,
    required this.templateBody,
    required this.category,
  });

  @override
  List<Object?> get props => [
        name,
        channel,
        description,
        templateSubject,
        templateBody,
        category,
      ];
}
