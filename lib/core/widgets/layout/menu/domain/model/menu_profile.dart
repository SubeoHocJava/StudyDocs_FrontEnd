class MenuProfile {
  final String userId;
  final String userName;
  final String fullName;
  final String? avatarUrl;
  final String? school;
  final int numMyUpload;
  final int numMyLikes;
  final int numMyComment;

  MenuProfile({
    required this.userId,
    required this.userName,
    required this.fullName,
    this.avatarUrl,
    this.school,
    required this.numMyUpload,
    required this.numMyLikes,
    required this.numMyComment,
  });
}
