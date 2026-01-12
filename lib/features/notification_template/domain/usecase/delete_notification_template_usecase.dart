
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';

class DeleteNotificationTemplateUseCase {
  final NotificationTemplateRepository repository;

  DeleteNotificationTemplateUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteTemplate(id);
  }
}
