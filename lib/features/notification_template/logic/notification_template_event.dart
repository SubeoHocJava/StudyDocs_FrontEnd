import 'package:equatable/equatable.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_request.dart';

abstract class NotificationTemplateEvent extends Equatable {
  const NotificationTemplateEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationTemplatesEvent extends NotificationTemplateEvent {
  const LoadNotificationTemplatesEvent();
}

class FilterNotificationTemplatesEvent extends NotificationTemplateEvent {
  final String query;
  final String? category;
  final String? channel;

  const FilterNotificationTemplatesEvent({
    this.query = '',
    this.category,
    this.channel,
  });

  @override
  List<Object?> get props => [query, category, channel];
}

class DeleteNotificationTemplateEvent extends NotificationTemplateEvent {
  final String id;

  const DeleteNotificationTemplateEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateNotificationTemplateEvent extends NotificationTemplateEvent {
  final NotificationTemplateEntity template;

  const UpdateNotificationTemplateEvent(this.template);

  @override
  List<Object?> get props => [template];
}

class CreateNotificationTemplateEvent extends NotificationTemplateEvent {
  final NotificationTemplateRequest template;

  const CreateNotificationTemplateEvent(this.template);

  @override
  List<Object?> get props => [template];
}
