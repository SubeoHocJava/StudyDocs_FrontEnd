import 'package:studydocs/features/notification_template/domain/entity/channel_entity.dart';

class ChannelModel extends ChannelEntity {
  const ChannelModel({
    required super.code,
    required super.name,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }
}
