import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../features/docs/data/model/document_model.dart';
import '../../features/docs/domain/entity/document_entity.dart';

abstract class DocsRemoteDataSource {
  Future<List<DocumentEntity>> getPublicDocuments({int page = 0, int size = 10});
  Future<List<DocumentEntity>> getNewestDocuments({int limit = 10});
  Future<List<DocumentEntity>> getMostLikedDocuments({int limit = 10});
  Future<DocumentEntity> getDocumentById(String id);
  Future<void> reactToDocument(String id, String type);
  Future<void> toggleSave(String id);
  Future<void> postComment(String docId, String content);
  Future<void> reactToReview({required String reviewId, required bool isLike});
  Future<Map<String, dynamic>> getDocumentStats(String docId);
  Future<String?> getMyDocumentReaction(String docId);
  Future<List<CommentEntity>> getReviewsByDocumentId(String docId, {int page = 0, int size = 10});
}

class DocsRemoteDataSourceImpl implements DocsRemoteDataSource {
  final DioClient dioClient;

  DocsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<DocumentEntity>> getPublicDocuments({int page = 0, int size = 10}) async {
    final response = await dioClient.get(
      '${ApiConstants.documentServiceUrl}${ApiConstants.publicDocument}',
      queryParameters: {'page': page, 'size': size},
    );
    // Handle Page<DocumentResponse>
    final data = response.data;
    if (data is Map && data.containsKey('content')) {
      final content = data['content'] as List;
      return content.map((json) => DocumentModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<List<DocumentEntity>> getNewestDocuments({int limit = 10}) async {
    final response = await dioClient.get(
      '${ApiConstants.documentServiceUrl}${ApiConstants.recentDocuments}',
      queryParameters: {'limit': limit},
    );
    final data = response.data;
    if (data is Map && data.containsKey('data')) {
       // ApiResponse wrapper?
       return (data['data'] as List).map((json) => DocumentModel.fromJson(json)).toList();
    } else if (data is List) {
       return data.map((json) => DocumentModel.fromJson(json)).toList();
    }
    // Fallback if wrapped in ApiResponse
    return [];
  }

  @override
  Future<List<DocumentEntity>> getMostLikedDocuments({int limit = 10}) async {
    final response = await dioClient.get(
      '${ApiConstants.documentServiceUrl}${ApiConstants.popularDocuments}',
      queryParameters: {'limit': limit},
    );
    final data = response.data;
     if (data is Map && data.containsKey('data')) {
       return (data['data'] as List).map((json) => DocumentModel.fromJson(json)).toList();
    } else if (data is List) {
       return data.map((json) => DocumentModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<DocumentEntity> getDocumentById(String id) async {
    final response = await dioClient.get(
      '${ApiConstants.documentServiceUrl}${ApiConstants.publicDocument}/$id',
    );
    final doc = DocumentModel.fromJson(response.data);
    
    // Fetch preview comments (top 5)
    try {
      final comments = await getReviewsByDocumentId(id, page: 0, size: 5);
      return doc.copyWith(comments: comments);
    } catch (e) {
      // If review service fails, return doc without comments
      return doc;
    }
  }

  @override
  Future<void> reactToDocument(String id, String type) async {
    // Review Service handles Document Reactions
    await dioClient.post(
      '${ApiConstants.reviewServiceUrl}/reviews/document/$id/react',
      queryParameters: {'type': type},
    );
  }

  @override
  Future<void> toggleSave(String id) async {
    // Assuming backend endpoint for save exists or using local storage logic?
    // For now assuming a backend endpoint exists:
    await dioClient.post(
      '${ApiConstants.documentServiceUrl}/documents/$id/save',
    );
  }

  @override
  Future<void> postComment(String docId, String content) async {
    await dioClient.post(
      '${ApiConstants.reviewServiceUrl}/reviews',
      data: {
        'documentId': docId,
        'comment': content,
      },
    );
  }

  @override
  Future<void> reactToReview({required String reviewId, required bool isLike}) async {
    await dioClient.post(
      '${ApiConstants.reviewServiceUrl}/reviews/$reviewId/react',
      queryParameters: {'type': isLike ? 'LIKE' : 'DISLIKE'}, // Backend expects type string? Controller says params 'type', endpoints '/react'
    );
  }

  @override
  Future<Map<String, dynamic>> getDocumentStats(String docId) async {
    final response = await dioClient.get(
      '${ApiConstants.reviewServiceUrl}/reviews/document/$docId/stats',
    );
     // Response: ApiResponse<DocumentStats> -> data: { documentId, likeCount, dislikeCount }
    return response.data;
  }

  @override
  Future<String?> getMyDocumentReaction(String docId) async {
    final response = await dioClient.get(
      '${ApiConstants.reviewServiceUrl}/reviews/document/$docId/reaction',
    );
    // Response: ApiResponse<ReactionType (String)> -> data: "LIKE" or null
    return response.data as String?;
  }

  @override
  Future<List<CommentEntity>> getReviewsByDocumentId(String docId, {int page = 0, int size = 10}) async {
    final response = await dioClient.get(
      '${ApiConstants.reviewServiceUrl}/reviews/document/$docId',
      queryParameters: {'page': page, 'size': size},
    );
    // Response: Page<ReviewResponse>
    final data = response.data;
    if (data is Map && data.containsKey('content')) {
      final content = data['content'] as List;
      return content.map((json) => _mapReviewToComment(json)).toList();
    }
    return [];
  }

  CommentEntity _mapReviewToComment(Map<String, dynamic> json) {
    // ReviewResponse: { id, userId, comment, likeCount... }
    // CommentEntity: { author, text }
    // We don't have author name in ReviewResponse, only userId. 
    // Ideally we fetch user info or ReviewResponse includes it. 
    // For now, prompt generic or placeholder.
    return CommentEntity(
      author: json['userId'] ?? 'User', 
      text: json['comment'] ?? '',
    );
  }
}
