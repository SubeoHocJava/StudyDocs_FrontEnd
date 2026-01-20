class DocumentEntity {
  final String? id; // Nullable for new uploads
  final String title;
  final String description;
  final String course;
  final String school;
  final String year;
  final String uploader;
  final String? uploaderId; // Added for navigation
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
  final DateTime? createdAt; // Added for grouping by date

  final String? subjectId; // Added subjectId
  final String? universityId; // Added universityId
  final int? commentsCount; // Added commentsCount

  DocumentEntity({
    this.id,
    required this.title,
    required this.description,
    required this.course,
    required this.school,
    required this.year,
    required this.uploader,
    this.uploaderId,
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
    this.subjectId,
    this.universityId,
    this.commentsCount,
    this.createdAt,
  });

  DocumentEntity copyWith({
    String? title,
    String? description, // Made optional
    String? course,
    String? school,
    String? year,
    String? uploader,
    String? uploaderId,
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
    String? subjectId,
    String? universityId,
    int? commentsCount,
  }) {
    return DocumentEntity(
      id: this.id, // ID should not change typically in copyWith, or use id ?? this.id if we add it to arguments. But currently it's not in arguments, so preserve this.id
      title: title ?? this.title,
      description: description ?? this.description,
      course: course ?? this.course,
      school: school ?? this.school,
      year: year ?? this.year,
      uploader: uploader ?? this.uploader,
      uploaderId: uploaderId ?? this.uploaderId,
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
      subjectId: subjectId ?? this.subjectId,
      universityId: universityId ?? this.universityId,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CommentEntity {
  final String author;
  final String text;
  final String? authorId; // Added authorId

  const CommentEntity({
    required this.author,
    required this.text,
    this.authorId,
  });

  CommentEntity copyWith({
    String? author,
    String? text,
    String? authorId,
  }) {
    return CommentEntity(
      author: author ?? this.author,
      text: text ?? this.text,
      authorId: authorId ?? this.authorId,
    );
  }

  @override
  String toString() => '$author: $text';
}