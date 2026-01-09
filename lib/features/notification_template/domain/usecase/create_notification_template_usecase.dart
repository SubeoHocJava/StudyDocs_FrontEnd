
import 'package:studydocs/features/notification_template/domain/entity/notification_template_entity.dart';
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';

class CreateNotificationTemplateUseCase {
  final NotificationTemplateRepository repository;

  CreateNotificationTemplateUseCase(this.repository);

  Future<void> call(NotificationTemplateEntity template) async {
    return await repository.createTemplate(template);
  }
}
