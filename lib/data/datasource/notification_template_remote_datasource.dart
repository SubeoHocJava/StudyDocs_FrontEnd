import 'package:studydocs/data/model/notification_template_model.dart';
import 'package:studydocs/features/notification_template/data/model/category_model.dart';
import 'package:studydocs/features/notification_template/data/model/channel_model.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_metadata_entity.dart';

abstract interface class NotificationTemplateDataSource {
  Future<List<NotificationTemplateModel>> getTemplates({
    String? query,
    String? type,
    String? channel,
  });

  Future<void> createTemplate(Map<String, dynamic> body);

  Future<void> updateTemplate(String id, Map<String, dynamic> body);

  Future<void> deleteTemplate(String id);

  Future<List<CategoryModel>> getCategories();

  Future<List<ChannelModel>> getChannels();

  Future<List<NotificationKeywordGroup>> searchKeywords(String query);
}

