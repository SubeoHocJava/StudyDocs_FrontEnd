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
    super.fileId, // Fixed: use super parameter for optional field
    super.currentUserReaction, required super.description,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      title: json['title'] ?? 'Untitled',
      course: json['subjectName'] ?? 'Unknown Course', // Placeholder if backend missing
      school: json['universityName'] ?? 'Unknown School', // Placeholder
      year: json['schoolYear'] ?? '2024-2025',
      uploader: json['uploadName'] ?? 'Unknown User', // Corrected key if needed, or keep uploaderName
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      comments: [], // Comments usually fetched separately
      isSaved: false,
      pages: json['totalPages'] ?? 0, // Backend might not track pages
      fileSize: json['fileSize'] != null ? formatBytes(json['fileSize'], 2) : "Unknown", // Backend might not return size
      // downloadUrl is no longer directly in DocumentResponse.
      // FE must use fileId to fetch it.
      downloadUrl: json['downloadUrl'] ?? '',
      fileId: json['fileId'], // Map fileId
      currentUserReaction: json['currentUserReaction'], 
      previewUrls: parsePreviews(json), description: '',
    );
  }

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    // Simple log usage or manual calculation to avoid dart:math import if possible,
    // but better to just use standard logic.
    // Assuming dart:math will be imported or using simplified logic:
    // Simple implementation without dart:math for safety if not imported:
    int i = 0;
    double d = bytes.toDouble();
    while (d >= 1024 && i < suffixes.length - 1) {
      d /= 1024;
      i++;
    }
    return '${d.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static List<String> parsePreviews(Map<String, dynamic> json) {
    if (json['previewDataView'] != null) {
      final data = json['previewDataView'];
      final baseUrl = data['baseUrl'] as String?;
      final key = data['key'] as String?;
      final totalPages = json['totalPages'] as int? ?? 0;

      if (baseUrl != null && key != null && totalPages > 0) {
        return List.generate(totalPages, (index) {
          return baseUrl.replaceFirst(key, '${index + 1}');
        });
      }
    }
    
    // Fallback to old list if exists
    if (json['previewUrls'] != null && json['previewUrls'] is List) {
      return List<String>.from(json['previewUrls']);
    }
    return [];
  }
}
