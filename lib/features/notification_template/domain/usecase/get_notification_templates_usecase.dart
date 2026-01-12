
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';

class GetNotificationTemplatesParams {
  final String? query;
  final String? type;
  final String? channel;

  GetNotificationTemplatesParams({this.query, this.type, this.channel});
}

class GetNotificationTemplatesUseCase {
  final NotificationTemplateRepository repository;

  GetNotificationTemplatesUseCase(this.repository);

  Future<List<NotificationTemplateEntity>> call([GetNotificationTemplatesParams? params]) async {
    return await repository.getTemplates(
      query: params?.query,
      type: params?.type,
      channel: params?.channel,
    );
  }
}
