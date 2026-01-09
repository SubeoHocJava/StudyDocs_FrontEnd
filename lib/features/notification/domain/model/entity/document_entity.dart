class DocumentEntity {
  final String id;
  final String title;
  final String course;
  final String school;
  final String year;
  final String uploader;
  final String uploaderAvatar;
  final int likes;
  final int dislikes;
  final bool isSaved;
  final List<CommentEntity> comments;

  DocumentEntity({
    required this.id,
    required this.title,
    required this.course,
    required this.school,
    required this.year,
    required this.uploader,
    required this.uploaderAvatar,
    required this.likes,
    required this.dislikes,
    required this.isSaved,
    required this.comments,
  });
}

class CommentEntity {
  final String author;
  final String text;
  CommentEntity({required this.author, required this.text});
}