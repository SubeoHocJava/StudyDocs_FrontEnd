import 'package:studydocs/data/datasource/notification_template_remote_datasource.dart';
import 'package:studydocs/features/notification_template/domain/entity/category_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/channel_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_metadata_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_request.dart';
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';

class NotificationTemplateRepositoryImpl implements NotificationTemplateRepository {
  final NotificationTemplateDataSource dataSource;

  NotificationTemplateRepositoryImpl({required this.dataSource});

  @override
  Future<List<NotificationTemplateEntity>> getTemplates({
    String? query,
    String? category,
    String? channel,
  }) async {
    return await dataSource.getTemplates(query: query, type: category, channel: channel);
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
  Future<void> createTemplate(NotificationTemplateRequest template) async {
    final body = {
      'name': template.name,
      'channel': {'code': template.channel.code, 'name': template.channel.name},
      'description': template.description,
      'templateSubject': template.templateSubject,
      'templateBody': template.templateBody,
      'category': {'code': template.category.code, 'name': template.category.name},
    };
     await dataSource.createTemplate(body);
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await dataSource.getCategories();
  }

  @override
  Future<List<ChannelEntity>> getChannels() async {
    return await dataSource.getChannels();
  }
  
  @override
  Future<List<NotificationKeywordGroup>> searchKeywords(String query) async {
    return await dataSource.searchKeywords(query);
  }
}
