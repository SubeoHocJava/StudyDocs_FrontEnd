import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/feat/notification/domain/entity/notification_model.dart';

class NotificationUIMapper {
  static Map<String, dynamic> getConfig(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return {
          'iconAsset': AppAssets.notiLike,
          'iconColor': null,
          'actionVerb': 'đã thích',
        };
      case NotificationType.comment:
        return {
          'iconAsset': AppAssets.notiComment,
          'iconColor': null,
          'actionVerb': 'đã bình luận về',
        };
      case NotificationType.download:
        return {
          'iconAsset': AppAssets.notiDownload,
          'iconColor': null,
          'actionVerb': 'đã tải',
        };
      case NotificationType.save:
        return {
          'iconAsset': AppAssets.notiSaved,
          'iconColor': null,
          'actionVerb': 'đã lưu',
        };
      case NotificationType.system:
      default:
        return {
          'iconAsset': AppAssets.logo,
          'iconColor': AppColors.primary,
          'actionVerb': 'đã gửi thông báo',
        };
    }
  }
}
