import 'package:studydocs/data/datasource/notification_template_remote_datasource.dart';
import 'package:studydocs/data/model/notification_template_model.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_metadata_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';

class NotificationTemplateRepositoryImpl implements NotificationTemplateRepository {
  final NotificationTemplateDataSource dataSource;

  NotificationTemplateRepositoryImpl({required this.dataSource});

  @override
  Future<List<NotificationTemplateEntity>> getTemplates({
    String? query,
    String? type,
    String? channel,
  }) async {
    return await dataSource.getTemplates(query: query, type: type, channel: channel);
  }

  @override
  Future<void> deleteTemplate(String id) async {
    await dataSource.deleteTemplate(id);
  }

  @override
  Future<void> updateTemplate(NotificationTemplateEntity template) async {
    final body = {
      'name': template.name,
      'description': template.description,
      'templateSubject': template.templateSubject,
      'templateBody': template.templateBody,
    };
    await dataSource.updateTemplate(template.id, body);
  }

  @override
  Future<void> createTemplate(NotificationTemplateEntity template) async {
    final body = {
      'name': template.name,
      'channel': template.channel,
      'description': template.description,
      'templateSubject': template.templateSubject,
      'templateBody': template.templateBody,
      'type': template.type,
    };
     await dataSource.createTemplate(body);
  }

  @override
  Future<List<String>> getTypes() async {
    return await dataSource.getTypes();
  }

  @override
  Future<List<String>> getChannels() async {
    return await dataSource.getChannels();
  }
  
  @override
  Future<List<NotificationKeywordGroup>> searchKeywords(String query) async {
    return await dataSource.searchKeywords(query);
  }
}
