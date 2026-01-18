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
    super.fileId,
    super.currentUserReaction, 
    required super.description,
    String? subjectId, // Explicitly declare argument
    String? universityId, // Explicitly declare argument
  }) : super(
         subjectId: subjectId,
         universityId: universityId,
       );

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id']?.toString(),
      title: json['title'] ?? 'Untitled',
      course: json['subjectName'] ?? 'Unknown Course', // Placeholder if backend missing
      school: json['universityName'] ?? 'Unknown School', // Placeholder
      year: json['schoolYear']?.toString() ?? '2024-2025',
      uploader: json['uploadName'] ?? json['userId']?.toString() ?? 'Unknown User',
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      comments: [], // Comments usually fetched separately
      isSaved: false,
      pages: (json['totalPages'] is int) 
          ? json['totalPages'] 
          : int.tryParse(json['totalPages']?.toString() ?? '0') ?? 0,
      fileSize: json['fileSize'] != null ? formatBytes(json['fileSize'], 2) : "Unknown", // Backend might not return size
      // downloadUrl is no longer directly in DocumentResponse.
      // FE must use fileId to fetch it.
      subjectId: json['subjectId']?.toString(),
      universityId: json['universityId']?.toString(),
      // Use backend URL if available, else construct fallback if fileId exists
      downloadUrl: json['downloadUrl'] ?? (json['fileId'] != null 
          ? 'http://172.16.17.86:8081/api/v1/files/${json['fileId']}' // Assuming Gateway/UploadService path
          : ''),
      fileId: json['fileId'],
      currentUserReaction: json['currentUserReaction'], 
      previewUrls: parsePreviews(json),
      description: json['description'] ?? '',
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

  DocumentModel copyWith({
    String? id,
    String? title,
    String? course,
    String? school,
    String? year,
    String? uploader,
    int? likes,
    int? dislikes,
    List<CommentEntity>? comments,
    bool? isSaved,
    int? pages,
    String? fileSize,
    String? downloadUrl,
    String? fileId,
    String? currentUserReaction,
    List<String>? previewUrls,
    String? description,
    String? subjectId,
    String? universityId,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      school: school ?? this.school,
      year: year ?? this.year,
      uploader: uploader ?? this.uploader,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      comments: comments ?? this.comments,
      isSaved: isSaved ?? this.isSaved,
      pages: pages ?? this.pages,
      fileSize: fileSize ?? this.fileSize,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      fileId: fileId ?? this.fileId,
      currentUserReaction: currentUserReaction ?? this.currentUserReaction,
      previewUrls: previewUrls ?? this.previewUrls,
      description: description ?? this.description,
      subjectId: subjectId ?? this.subjectId,
      universityId: universityId ?? this.universityId,
    );
  }

  static List<String> parsePreviews(Map<String, dynamic> json) {
    if (json['previewDataView'] != null) {
      final data = json['previewDataView'];
      final baseUrl = data['baseUrl'] as String?;
      final key = data['key'] as String?;
      final totalPages = json['totalPages'] as int? ?? 0;

      if (baseUrl != null && key != null && totalPages > 0) {
        return List.generate(totalPages, (index) {
          String url = baseUrl.replaceFirst(key, '${index + 1}');
           // Remove .pdf if present
          if (url.endsWith('.pdf')) {
            url = url.substring(0, url.length - 4);
          }
           // Force .jpg extension so Cloudinary converts PDF page to Image
          if (!url.endsWith('.jpg')) {
            url += '.jpg';
          }
          return url;
        });
      }
      
      // Handle case with 'PAGE_NUMBER_PLACEHOLDER'
      if (baseUrl != null && totalPages > 0 && baseUrl.contains('PAGE_NUMBER_PLACEHOLDER')) {
         return List.generate(totalPages, (index) {
          String url = baseUrl.replaceFirst('PAGE_NUMBER_PLACEHOLDER', '${index + 1}');
          // Note: If using R2 and files are PDFs, CachedNetworkImage won't work.
          // Assuming UploadService generates image previews or we use a viewer.
          // For now, removing the forced .jpg logic if it seems like a direct file link that might not be Cloudinary key-based.
          // But preserving it if it's likely needed.
          // Safer to check extensions.
          
          if (url.endsWith('.pdf')) {
            // If it's a PDF link, CachedNetworkImage will fail. 
            // We hope the backend provided an Image URL.
            // If we MUST convert, typically we need an image endpoint.
            // Leaving as is, but removing the double extension risk.
          } else if (!url.endsWith('.jpg') && !url.endsWith('.png') && !url.endsWith('.jpeg')) {
             // If no extension, maybe append jpg? 
             // url += '.jpg';
          }
          return url;
        });
      }
    }
    
    // Fallback: Cloudinary (if fileId exists)
    // URL format: https://res.cloudinary.com/<cloud_name>/image/upload/<fileId>.jpg
    // Note: 'dnk892k4r' is a placeholder/guessed cloud name. 
    // If your cloud name is different, please update it here or in a config file.
    if (json['fileId'] != null) {
      final fileId = json['fileId'].toString();
      // Assuming PDF preview for page 1 (pg_1)
      return ['https://res.cloudinary.com/dnk892k4r/image/upload/pg_1/$fileId.jpg']; 
    }

    // Fallback to old list if exists
    if (json['previewUrls'] != null && json['previewUrls'] is List) {
      return List<String>.from(json['previewUrls']);
    }
    return [];
  }
}
