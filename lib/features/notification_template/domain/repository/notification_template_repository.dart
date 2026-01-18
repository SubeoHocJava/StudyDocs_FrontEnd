import 'package:studydocs/features/notification_template/domain/entity/category_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/channel_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_metadata_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_request.dart';

abstract class NotificationTemplateRepository {
  Future<List<NotificationTemplateEntity>> getTemplates({
    String? query,
    String? category, // Renamed from type
    String? channel,
  });

  Future<void> createTemplate(NotificationTemplateRequest template);

  Future<void> updateTemplate(NotificationTemplateEntity template);

  Future<void> deleteTemplate(String id);

  Future<List<CategoryEntity>> getCategories(); // Renamed and return type changed

  Future<List<ChannelEntity>> getChannels(); // Return type changed
  Future<List<NotificationKeywordGroup>> searchKeywords(String query);
}
