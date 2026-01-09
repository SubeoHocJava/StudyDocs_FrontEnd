import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/model/notification_template_model.dart';
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

  Future<List<String>> getTypes();

  Future<List<String>> getChannels();

  Future<List<NotificationKeywordGroup>> searchKeywords(String query);
}

class NotificationTemplateDataSourceImpl
    implements NotificationTemplateDataSource {
  final DioClient dioClient;
  final String path = "/notification-templates";

  // Dữ liệu giả lập (Mock Data)
  final List<NotificationTemplateModel> _mockData = [
    NotificationTemplateModel(
      id: '1',
      name: 'Welcome Email',
      channel: 'EMAIL',
      description: 'Gửi cho người dùng mới',
      templateSubject: 'Chào mừng {userName}!',
      templateBody: 'Xin chào {userName}, chào mừng bạn đến với nền tảng.',
      type: 'SYSTEM',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    NotificationTemplateModel(
      id: '2',
      name: 'Like Notification',
      channel: 'PUSH',
      description: 'Khi ai đó thích bài viết',
      templateSubject: '{actorName} thích bài viết của bạn',
      templateBody: '{actorName} thích bài viết: "{postTitle}"',
      type: 'LIKE',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    NotificationTemplateModel(
      id: '3',
      name: 'HTML Example',
      channel: 'EMAIL',
      description: 'Mẫu email định dạng HTML',
      templateSubject: 'Thông báo quan trọng gửi đến {userName}',
      templateBody:
          '<h3>Xin chào <b>{userName}</b>!</h3><p>Đây là một ví dụ về <i>nội dung HTML</i>.</p><p>Bạn có thể:</p><ul><li><b>In đậm</b> văn bản</li><li><i>In nghiêng</i> văn bản</li><li>Tạo danh sách</li></ul><p style="color: blue">Thay đổi màu sắc...</p>',
      type: 'CUSTOM',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  NotificationTemplateDataSourceImpl({required this.dioClient});

  @override
  Future<List<NotificationTemplateModel>> getTemplates({
    String? query,
    String? type,
    String? channel,
  }) async {
    // CÀI ĐẶT THỰC TẾ (Đang comment)
    /*
    final Map<String, dynamic> queryParams = {};
    if (query != null && query.isNotEmpty) queryParams['name'] = query; // Backend uses 'name' for search
    if (type != null && type.isNotEmpty) queryParams['type'] = type;
    if (channel != null && channel.isNotEmpty) queryParams['channel'] = channel;

    // Use /search for filtering if any param is present, otherwise get all might be sufficient but search is safer for filtering
    final endpoint = "$path/search";

    final response = await dioClient.get(endpoint, queryParameters: queryParams);
    return (response.data as List)
        .map((e) => NotificationTemplateModel.fromJson(e))
        .toList();
    */

    // GIẢ LẬP ĐỘ TRỄ MẠNG VÀ PHẢN HỒI
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockData.where((element) {
      final matchesQuery =
          query == null ||
          query.isEmpty ||
          element.name.toLowerCase().contains(query.toLowerCase());
      final matchesType = type == null || type.isEmpty || element.type == type;
      final matchesChannel =
          channel == null || channel.isEmpty || element.channel == channel;
      return matchesQuery && matchesType && matchesChannel;
    }).toList();
  }

  @override
  Future<void> createTemplate(Map<String, dynamic> body) async {
    // CÀI ĐẶT THỰC TẾ
    /*
    await dioClient.post(path, data: body);
    */

    // GIẢ LẬP
    await Future.delayed(const Duration(milliseconds: 500));
    final newModel = NotificationTemplateModel.fromJson({
      ...body,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
    _mockData.add(newModel);
  }

  @override
  Future<void> updateTemplate(String id, Map<String, dynamic> body) async {
    // CÀI ĐẶT THỰC TẾ
    /*
    await dioClient.put("$path/$id", data: body);
    */

    // GIẢ LẬP
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockData.indexWhere((e) => e.id == id);
    if (index != -1) {
      final oldModel = _mockData[index];
      // Merge old data with new updates
      final updatedJson = oldModel.toJson();
      updatedJson.addAll(body);
      updatedJson['updatedAt'] = DateTime.now().toIso8601String();

      _mockData[index] = NotificationTemplateModel.fromJson(updatedJson);
    }
  }

  @override
  Future<void> deleteTemplate(String id) async {
    // CÀI ĐẶT THỰC TẾ
    /*
    await dioClient.delete("$path/$id");
    */

    // GIẢ LẬP
    await Future.delayed(const Duration(milliseconds: 500));
    _mockData.removeWhere((element) => element.id == id);
  }

  @override
  Future<List<String>> getTypes() async {
    // CÀI ĐẶT THỰC TẾ
    /*
    final response = await dioClient.get("$path/types");
    return List<String>.from(response.data);
    */

    // GIẢ LẬP
    await Future.delayed(const Duration(milliseconds: 300));
    return ['LIKE', 'COMMENT', 'SYSTEM', 'CUSTOM'];
  }

  @override
  Future<List<String>> getChannels() async {
    // CÀI ĐẶT THỰC TẾ
    /*
    final response = await dioClient.get("$path/channels");
    return List<String>.from(response.data);
    */

    // GIẢ LẬP
    await Future.delayed(const Duration(milliseconds: 300));
    return ['EMAIL', 'PUSH', 'SMS'];
  }

  @override
  Future<List<NotificationKeywordGroup>> searchKeywords(String query) async {
    // CÀI ĐẶT THỰC TẾ
    /*
    final response = await dioClient.get("$path/search", queryParameters: {'q': query}); // Assuming 'search' endpoint
    return (response.data as List).map((e) => NotificationKeywordGroup.fromJson(e)).toList();
    */

    // GIẢ LẬP
    await Future.delayed(const Duration(milliseconds: 300));

    final allGroups = [
      NotificationKeywordGroup(
        name: 'Người dùng',
        keywords: [
          NotificationKeyword(label: 'Tên người dùng', key: '{userName}'),
          NotificationKeyword(label: 'Email người dùng', key: '{userEmail}'),
        ],
      ),
      NotificationKeywordGroup(
        name: 'Bài viết',
        keywords: [
          NotificationKeyword(label: 'Tiêu đề bài viết', key: '{postTitle}'),
          NotificationKeyword(label: 'Tác giả bài viết', key: '{postAuthor}'),
        ],
      ),
    ];

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
