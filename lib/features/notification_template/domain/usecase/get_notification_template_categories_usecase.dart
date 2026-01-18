
import 'package:studydocs/features/notification_template/domain/entity/category_entity.dart';
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';

class GetNotificationTemplateCategoriesUseCase {
  final NotificationTemplateRepository repository;

  GetNotificationTemplateCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
}
