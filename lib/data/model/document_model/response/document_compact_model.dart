import 'package:studydocs/core/utils/image_utils.dart';

class DocumentCompactModel {
  final String id;
  final String title;
  final String? thumbnail;

  const DocumentCompactModel({
    required this.id,
    required this.title,
    this.thumbnail,
  });

  factory DocumentCompactModel.fromJson(Map<String, dynamic> json) {
    return DocumentCompactModel(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnail: ImageUtils.fixPdfThumbnail(json['thumbnail'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
    };
  }
}
