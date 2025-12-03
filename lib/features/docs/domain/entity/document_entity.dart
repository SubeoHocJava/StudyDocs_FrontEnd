class DocumentEntity {
  final String title;
  final String course;
  final String school;
  final String year;
  final String uploader;
  final int likes;
  final int dislikes;
  final List<CommentEntity> comments;
  final bool isSaved;

  DocumentEntity({
    required this.title,
    required this.course,
    required this.school,
    required this.year,
    required this.uploader,
    required this.likes,
    required this.dislikes,
    required this.comments,
    this.isSaved = false,
  });
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