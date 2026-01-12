
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';

class GetNotificationTemplateTypesUseCase {
  final NotificationTemplateRepository repository;

  GetNotificationTemplateTypesUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.getTypes();
  }
}
