
import 'package:studydocs/features/notification_template/domain/entity/channel_entity.dart';
import 'package:studydocs/features/notification_template/domain/repository/notification_template_repository.dart';

class GetNotificationTemplateChannelsUseCase {
  final NotificationTemplateRepository repository;

  GetNotificationTemplateChannelsUseCase(this.repository);

  Future<List<ChannelEntity>> call() async {
    return await repository.getChannels();
  }
}
