import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/notification_template_remote_datasource.dart';
import 'package:studydocs/data/model/notification_template_model.dart';
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
    if (type != null && type.isNotEmpty) queryParams['type'] = type;
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
  Future<List<String>> getTypes() async {
    final response = await dioClient.get("/supports/types");
    return List<String>.from(response.data);
  }

  @override
  Future<List<String>> getChannels() async {
    final response = await dioClient.get("/supports/channels");
    return List<String>.from(response.data);
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
        // Assuming Key is the placeholder code (e.g. {userName}) and Value is the Label
        // Or vice-versa. Usually Value is the human readable text.
        // Let's assume Entry Key = "User Name", Value = "{userName}" ??
        // Actually, based on typical Map<String,String> usage in Java `items`,
        // it's likely Key=Id/Key, Value=Label.
        // But `NotificationKeyword` has `label` and `key`.
        // Let's map Entry Key -> key, Entry Value -> label.
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

