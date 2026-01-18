import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/notification_template_remote_datasource.dart';
import 'package:studydocs/data/model/notification_template_model.dart';
import 'package:studydocs/features/notification_template/data/model/category_model.dart';
import 'package:studydocs/features/notification_template/data/model/channel_model.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_metadata_entity.dart';
import 'package:studydocs/data/model/notification_metadata.dart';

class NotificationTemplateDataSourceImpl
    implements NotificationTemplateDataSource {
  final DioClient dioClient;
  final String path = "/notifications/templates";

  NotificationTemplateDataSourceImpl({required this.dioClient});

  @override
  Future<List<NotificationTemplateModel>> getTemplates({
    String? query,
    String? type,
    String? channel,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (query != null && query.isNotEmpty) {
      queryParams['name'] = query;
    }
    if (type != null && type.isNotEmpty) queryParams['category'] = type;
    if (channel != null && channel.isNotEmpty) queryParams['channel'] = channel;

    final endpoint = "$path/search";

    final response = await dioClient.get(endpoint, queryParameters: queryParams);
    return (response.data as List)
        .map((e) => NotificationTemplateModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> createTemplate(Map<String, dynamic> body) async {
    await dioClient.post(path, data: body);
  }

  @override
  Future<void> updateTemplate(String id, Map<String, dynamic> body) async {
    await dioClient.put("$path/$id", data: body);
  }

  @override
  Future<void> deleteTemplate(String id) async {
    await dioClient.delete("$path/$id");
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await dioClient.get("/notifications/supports/types");
    return (response.data as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<ChannelModel>> getChannels() async {
    final response = await dioClient.get("/notifications/supports/channels");
    return (response.data as List)
        .map((e) => ChannelModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<NotificationKeywordGroup>> searchKeywords(String query) async {
    // Backend endpoint for metadata
    final response = await dioClient.get("/notifications/metadata");
    final data = (response.data as List)
        .map((e) => NotificationMetadata.fromJson(e))
        .toList();

    // Map to domain entity and filter
    final allGroups = data.map((meta) {
      final keywords = meta.items.entries.map((entry) {
        return NotificationKeyword(label: entry.value, key: entry.key);
      }).toList();

      return NotificationKeywordGroup(name: meta.groupName, keywords: keywords);
    }).toList();

    if (query.isEmpty) return allGroups;

    return allGroups
        .where(
          (g) =>
              g.name.toLowerCase().contains(query.toLowerCase()) ||
              g.keywords.any(
                (k) => k.label.toLowerCase().contains(query.toLowerCase()),
              ),
        )
        .toList();
  }
}

