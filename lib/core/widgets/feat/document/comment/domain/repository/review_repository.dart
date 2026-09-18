import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/author.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/content.dart';
import 'package:studydocs/data/datasource/review_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/review_remote_datasource_impl.dart';
import 'package:studydocs/core/network/token_services.dart';

abstract interface class ReviewRepository {
  //Chỉ xử lý cho text cho hiện tại
  Future<void> comment(String documentId, String content);
  Future<void> replyComment(String documentId, String commentId, String content);
  Future<List<Comment>> getComments(String documentId);
  Future<List<Comment>> getReplies(String documentId, String commentId);
  Future<void> likeComment(String documentId, String commentId);
  Future<void> unlikeComment(String documentId, String commentId);
  Future<void> editComment(String documentId, String commentId, String content);
  Future<void> deleteComment(String documentId, String commentId);
}

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource _dataSource;
  final TokenStorageService _tokenStorage;

  ReviewRepositoryImpl({ReviewRemoteDataSource? dataSource, TokenStorageService? tokenStorage})
      : _dataSource = dataSource ?? ReviewRemoteDataSourceImpl(),
        _tokenStorage = tokenStorage ?? TokenStorageService();

  @override
  Future<void> comment(String documentId, String content) async {
    await _dataSource.addReview(documentId, content, 5); // Default rating 5 for now
  }

  @override
  Future<void> replyComment(String documentId, String commentId, String content) async {
    await _dataSource.replyToReview(commentId, content);
  }

  @override
  Future<List<Comment>> getComments(String documentId) async {
    final data = await _dataSource.getReviewsForDocument(documentId);
    if (data == null) return [];
    
    List rawList = [];
    if (data is List) {
      rawList = data;
    } else if (data is Map<String, dynamic>) {
      rawList = data['content'] as List? ?? [];
    }
    
    final currentUserId = await _tokenStorage.getUserId();
    return rawList
        .map((item) => _mapComment(Map<String, dynamic>.from(item), currentUserId))
        .toList();
  }

  @override
  Future<List<Comment>> getReplies(String documentId, String commentId) async {
    final data = await _dataSource.getRepliesForReview(commentId);
    if (data == null) return [];

    List rawList = [];
    if (data is List) {
      rawList = data;
    } else if (data is Map<String, dynamic>) {
      rawList = data['content'] as List? ?? [];
    }

    final currentUserId = await _tokenStorage.getUserId();
    return rawList
        .map((item) => _mapComment(Map<String, dynamic>.from(item), currentUserId))
        .toList();
  }

  @override
  Future<void> likeComment(String documentId, String commentId) async {
    await _dataSource.interactWithReview(commentId, 'LIKE');
  }

  @override
  Future<void> unlikeComment(String documentId, String commentId) async {
    // In review-service, sending the same interaction type toggles it off
    await _dataSource.interactWithReview(commentId, 'LIKE');
  }

  @override
  Future<void> editComment(String documentId, String commentId, String content) async {
    await _dataSource.updateReview(commentId, content);
  }

  @override
  Future<void> deleteComment(String documentId, String commentId) async {
    await _dataSource.deleteReview(commentId);
  }

  Comment _mapComment(Map<String, dynamic> json, String? currentUserId) {
    final String authorId = json['userId']?.toString() ?? '';
    return Comment(
      id: json['id']?.toString() ?? '',
      documentId: json['documentId']?.toString() ?? '',
      contents: [TextBlock((json['comment'] ?? json['content'])?.toString() ?? '')],
      author: Author(
        id: authorId,
        fullName: json['username']?.toString() ?? 'Anonymous',
        avatarUrl: json['userAvatar']?.toString() ?? 'https://ui-avatars.com/api/?name=User',
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      likeCount: json['likeCount'] as int? ?? 0,
      isLiked: false, 
      isMine: currentUserId != null && currentUserId == authorId,
      replyToCommentId: json['parentId']?.toString(),
      replyCount: json['replyCount'] as int? ?? 0,
      children: json['replies'] != null
          ? (json['replies'] as List)
              .map((item) => _mapComment(Map<String, dynamic>.from(item), currentUserId))
              .toList()
          : const [],
    );
  }
}
