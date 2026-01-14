class CommentEntity {
  final String id;
  final String username;
  final String? avatarUrl;
  final String content;
  final String createdAt;

  CommentEntity({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.content,
    required this.createdAt,
  });
}
