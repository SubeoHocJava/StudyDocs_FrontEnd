class DocumentEntity {
  final String? id; // Nullable for new uploads
  final String title;
  final String description;
  final String course;
  final String school;
  final String year;
  final String uploader;
  final int likes;
  final int dislikes;
  final List<CommentEntity> comments;
  final bool isSaved;
  final int pages;
  final String fileSize;
  final String downloadUrl;
  final String? fileId; // Added fileId
  final String? currentUserReaction; // Added for Review Service integration
  final List<String> previewUrls;

  DocumentEntity({
    this.id,
    required this.title,
    required this.description,
    required this.course,
    required this.school,
    required this.year,
    required this.uploader,
    required this.likes,
    required this.dislikes,
    required this.comments,
    this.isSaved = false,
    required this.pages,
    required this.fileSize,
    required this.downloadUrl,
    this.fileId,
    this.currentUserReaction,
    required this.previewUrls,
  });

  DocumentEntity copyWith({
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
  }) {
    return DocumentEntity(
      title: title ?? this.title,
      description: description ?? this.description,
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
    );
  }
}

class CommentEntity {
  final String author;
  final String text;

  const CommentEntity({
    required this.author,
    required this.text,
  });

  @override
  String toString() => '$author: $text';
}