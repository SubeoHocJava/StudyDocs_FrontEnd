import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';

class NotificationSection {
  final String title;
  final List<NotificationEntity> items;

  const NotificationSection({
    required this.title,
    required this.items,
  });

  bool get isEmpty => items.isEmpty;
}
