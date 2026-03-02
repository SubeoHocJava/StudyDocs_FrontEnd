/// Model gọn cho card DỌC — dùng khi hiển thị danh sách dạng grid/carousel
/// Payload nhỏ hơn → API trả về nhanh hơn khi có nhiều item
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
      thumbnail: json['thumbnail'] as String?,
    );
  }
}
