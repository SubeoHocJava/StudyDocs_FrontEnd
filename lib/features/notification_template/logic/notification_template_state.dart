import 'package:equatable/equatable.dart';
import 'package:studydocs/features/notification_template/domain/entity/category_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/channel_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_metadata_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';

enum NotificationTemplateStatus { initial, loading, success, failure }

class NotificationTemplateState extends Equatable {
  final NotificationTemplateStatus status;
  final List<NotificationTemplateEntity> templates;
  final List<NotificationTemplateEntity> allTemplates;
  final List<CategoryEntity> categories;
  final List<ChannelEntity> channels;
  final List<NotificationKeywordGroup> keywords;
  final String? errorMessage;

  const NotificationTemplateState({
    this.status = NotificationTemplateStatus.initial,
    this.templates = const [],
    this.allTemplates = const [],
    this.categories = const [],
    this.channels = const [],
    this.keywords = const [],
    this.errorMessage,
  });

  NotificationTemplateState copyWith({
    NotificationTemplateStatus? status,
    List<NotificationTemplateEntity>? templates,
    List<NotificationTemplateEntity>? allTemplates,
    List<CategoryEntity>? categories, // Renamed from types
    List<ChannelEntity>? channels, // Type changed
    List<NotificationKeywordGroup>? keywords,
    String? errorMessage,
  }) {
    return NotificationTemplateState(
      status: status ?? this.status,
      templates: templates ?? this.templates,
      allTemplates: allTemplates ?? this.allTemplates,
      categories: categories ?? this.categories, // Renamed from types
      channels: channels ?? this.channels,
      keywords: keywords ?? this.keywords,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, templates, allTemplates, categories, channels, keywords, errorMessage]; // Renamed types to categories
}
