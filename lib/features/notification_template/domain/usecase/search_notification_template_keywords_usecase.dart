
import 'package:studydocs/features/notification_template/domain/entity/notification_metadata_entity.dart';
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';

class SearchNotificationTemplateKeywordsUseCase {
  final NotificationTemplateRepository repository;

  SearchNotificationTemplateKeywordsUseCase(this.repository);

  Future<List<NotificationKeywordGroup>> call(String query) async {
    return await repository.searchKeywords(query);
  }
}
