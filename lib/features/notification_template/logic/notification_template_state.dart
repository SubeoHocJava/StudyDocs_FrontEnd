import 'package:equatable/equatable.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_metadata_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';

enum NotificationTemplateStatus { initial, loading, success, failure }

class NotificationTemplateState extends Equatable {
  final NotificationTemplateStatus status;
  final List<NotificationTemplateEntity> templates;
  final List<NotificationTemplateEntity> allTemplates;
  final List<String> types;
  final List<String> channels;
  final List<NotificationKeywordGroup> keywords;
  final String? errorMessage;

  const NotificationTemplateState({
    this.status = NotificationTemplateStatus.initial,
    this.templates = const [],
    this.allTemplates = const [],
    this.types = const [],
    this.channels = const [],
    this.keywords = const [],
    this.errorMessage,
  });

  NotificationTemplateState copyWith({
    NotificationTemplateStatus? status,
    List<NotificationTemplateEntity>? templates,
    List<NotificationTemplateEntity>? allTemplates,
    List<String>? types,
    List<String>? channels,
    List<NotificationKeywordGroup>? keywords,
    String? errorMessage,
  }) {
    return NotificationTemplateState(
      status: status ?? this.status,
      templates: templates ?? this.templates,
      allTemplates: allTemplates ?? this.allTemplates,
      types: types ?? this.types,
      channels: channels ?? this.channels,
      keywords: keywords ?? this.keywords,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, templates, allTemplates, types, channels, keywords, errorMessage];
}
