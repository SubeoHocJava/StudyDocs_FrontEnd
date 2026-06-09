import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/author.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/content.dart';
import 'package:studydocs/core/network/dio_client.dart';
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
  final DioClient _dioClient;
  final TokenStorageService _tokenStorage;

  ReviewRepositoryImpl({DioClient? dioClient, TokenStorageService? tokenStorage})
      : _dioClient = dioClient ?? DioClient(),
        _tokenStorage = tokenStorage ?? TokenStorageService();

  @override
  Future<void> comment(String documentId, String content) async {
    await _dioClient.post('reviews', data: {
      'documentId': documentId,
      'documentTitle': 'Tài liệu',
      'content': content,
    });
  }

  @override
  Future<void> replyComment(String documentId, String commentId, String content) async {
    await _dioClient.post('reviews/$commentId/replies', data: {
      'content': content,
    });
  }

  @override
  Future<List<Comment>> getComments(String documentId) async {
    final response = await _dioClient.get('documents/$documentId/reviews');
    final data = response.data;
    if (data == null) return [];
    
    final rawList = data['content'] as List? ?? [];
    final currentUserId = await _tokenStorage.getUserId();
    return rawList
        .map((item) => _mapComment(Map<String, dynamic>.from(item), currentUserId))
        .toList();
  }

  @override
  Future<List<Comment>> getReplies(String documentId, String commentId) async {
    final response = await _dioClient.get('reviews/$commentId/replies');
    final data = response.data;
    if (data == null) return [];

    final rawList = data['content'] as List? ?? [];
    final currentUserId = await _tokenStorage.getUserId();
    return rawList
        .map((item) => _mapComment(Map<String, dynamic>.from(item), currentUserId))
        .toList();
  }

  @override
  Future<void> likeComment(String documentId, String commentId) async {
    await _dioClient.post('reviews/$commentId/interactions', data: {'type': 'LIKE'});
  }

  @override
  Future<void> unlikeComment(String documentId, String commentId) async {
    // In review-service, sending the same interaction type toggles it off
    await _dioClient.post('reviews/$commentId/interactions', data: {'type': 'LIKE'});
  }

  @override
  Future<void> editComment(String documentId, String commentId, String content) async {
    await _dioClient.put('reviews/$commentId', data: {'content': content});
  }

  @override
  Future<void> deleteComment(String documentId, String commentId) async {
    await _dioClient.delete('reviews/$commentId');
  }

  Comment _mapComment(Map<String, dynamic> json, String? currentUserId) {
    final String authorId = json['userId']?.toString() ?? '';
    return Comment(
      id: json['id']?.toString() ?? '',
      documentId: json['documentId']?.toString() ?? '',
      contents: [TextBlock(json['content']?.toString() ?? '')],
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
