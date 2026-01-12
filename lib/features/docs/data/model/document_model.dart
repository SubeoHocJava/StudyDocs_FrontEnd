import '../../../docs/domain/entity/document_entity.dart';

class DocumentModel extends DocumentEntity {
  DocumentModel({
    super.id,
    required super.title,
    required super.course,
    required super.school,
    required super.year,
    required super.uploader,
    required super.likes,
    required super.dislikes,
    required super.comments,
    super.isSaved,
    required super.pages,
    required super.fileSize,
    required super.downloadUrl,
    required super.previewUrls,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      title: json['title'] ?? 'Untitled',
      course: json['subjectName'] ?? 'Unknown Course', // Placeholder if backend missing
      school: json['universityName'] ?? 'Unknown School', // Placeholder
      year: json['schoolYear'] ?? '2024-2025',
      uploader: json['uploaderName'] ?? 'Unknown User', // Placeholder
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      comments: [], // Comments usually fetched separately
      isSaved: false,
      pages: 0, // Backend might not track pages
      fileSize: "0 MB", // Backend might not return size
      downloadUrl: json['url'] ?? '',
      previewUrls: [],
    );
  }
}
