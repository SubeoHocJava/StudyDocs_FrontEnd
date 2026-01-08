import 'package:studydocs/features/notification_template/domain/entity/notification_metadata_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';

abstract class NotificationTemplateRepository {
  Future<List<NotificationTemplateEntity>> getTemplates({
    String? query,
    String? type,
    String? channel,
  });
  Future<void> deleteTemplate(String id);
  Future<void> updateTemplate(NotificationTemplateEntity template);
  Future<void> createTemplate(NotificationTemplateEntity template);
  Future<List<String>> getTypes();
  Future<List<String>> getChannels();
  Future<List<NotificationKeywordGroup>> getKeywords();
}
