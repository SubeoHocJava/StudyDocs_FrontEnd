import 'package:studydocs/features/notification_template/data/model/notification_template_model.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_metadata_entity.dart';
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';

class NotificationTemplateRepositoryImpl implements NotificationTemplateRepository {
  // Mock Data
  final List<NotificationTemplateModel> _mockData = [
    NotificationTemplateModel(
      id: '1',
      name: 'Like Document Template',
      channel: 'EMAIL',
      description: 'Notify when someone likes your document',
      templateSubject: 'Thông báo có người đã thích tài liệu đăng tải',
      templateBody: 'Người dùng {user} đã thích tài liệu {document} của bạn.',
      type: 'LIKE',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now(),
    ),
    NotificationTemplateModel(
      id: '2',
      name: 'Download Document Template',
      channel: 'PUSH',
      description: 'Notify when someone downloads your document',
      templateSubject: 'Thông báo có người đã tải xuống tài liệu',
      templateBody: 'Người dùng {user} đã tải xuống tài liệu {document} của bạn.',
      type: 'DOWNLOAD',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<NotificationTemplateEntity>> getTemplates({
    String? query,
    String? type,
    String? channel,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    
    return _mockData.where((t) {
      final matchesQuery = query == null || query.isEmpty ||
             t.name.toLowerCase().contains(query.toLowerCase()) ||
             t.templateSubject.toLowerCase().contains(query.toLowerCase()) ||
             t.channel.toLowerCase().contains(query.toLowerCase());
             
      final matchesType = type == null || type.isEmpty || t.type == type;
      final matchesChannel = channel == null || channel.isEmpty || t.channel == channel;

      return matchesQuery && matchesType && matchesChannel;
    }).toList();
  }

  @override
  Future<void> deleteTemplate(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockData.removeWhere((element) => element.id == id);
  }

  @override
  Future<void> updateTemplate(NotificationTemplateEntity template) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockData.indexWhere((element) => element.id == template.id);
    if (index != -1) {
      _mockData[index] = NotificationTemplateModel(
        id: template.id,
        name: template.name,
        channel: template.channel,
        description: template.description,
        templateSubject: template.templateSubject,
        templateBody: template.templateBody,
        type: template.type,
        createdAt: template.createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> createTemplate(NotificationTemplateEntity template) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockData.add(NotificationTemplateModel(
      id: template.id,
      name: template.name,
      channel: template.channel,
      description: template.description,
      templateSubject: template.templateSubject,
      templateBody: template.templateBody,
      type: template.type,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
  }

  @override
  Future<List<String>> getTypes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ['LIKE', 'COMMENT', 'NEW_POST', 'SYSTEM', 'CUSTOM'];
  }

  @override
  Future<List<String>> getChannels() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ['EMAIL', 'PUSH', 'SMS'];
  }
  @override
  Future<List<NotificationKeywordGroup>> getKeywords() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      NotificationKeywordGroup(
        name: 'Thông tin người dùng',
        keywords: [
          NotificationKeyword(label: 'Tên người nhận', key: '\$user.name'),
          NotificationKeyword(label: 'ID người nhận', key: '\$user.id'),
          NotificationKeyword(label: 'Email người nhận', key: '\$user.email'),
        ],
      ),
      NotificationKeywordGroup(
        name: 'Thông tin tài liệu',
        keywords: [
          NotificationKeyword(label: 'Tiêu đề tài liệu', key: '\$document.title'),
          NotificationKeyword(label: 'ID tài liệu', key: '\$document.id'),
          NotificationKeyword(label: 'Loại tài liệu', key: '\$document.type'),
        ],
      ),
      NotificationKeywordGroup(
        name: 'Thông tin hệ thống',
        keywords: [
          NotificationKeyword(label: 'Ngày hiện tại', key: '\$system.date'),
          NotificationKeyword(label: 'Giờ hiện tại', key: '\$system.time'),
        ],
      ),
    ];
  }
}
