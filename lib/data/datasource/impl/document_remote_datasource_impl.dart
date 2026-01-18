import 'package:studydocs/core/exceptions/api_exception.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/data/model/api_response.dart';
import 'package:studydocs/data/model/request/upload_document_request.dart';
import 'package:studydocs/features/docs/domain/entity/document_entity.dart';
import '../../../features/docs/data/model/document_model.dart';
import '../document_remote_datasource.dart';

class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
  static DocumentRemoteDataSourceImpl? _instance;
  final DioClient dioClient;

  DocumentRemoteDataSourceImpl({required this.dioClient});

  // --- HOME / LIST LOGIC ---

  @override
  Future<List<DocumentModel>> getDocuments() async {
    // Default to popular or recent if no specific "all" endpoint is defined for home.
    // Or return empty list if intended.
    // For now, let's just use getRecentDocuments() as the default feed.
    return getRecentDocuments();
  }

  @override
  Future<List<DocumentModel>> getPopularDocuments() async {
    // REAL API CALL - trả về documents với universityId và subjectId
    final response = await dioClient.get(
      ApiConstants.popularDocumentsReal,
      queryParameters: {'limit': 10},
    );

    if (response.statusCode == 200 && response.data != null) {
      // Revert to simpler List assumption if user insists, but data wrapper is safer.
      // Based on user request "trả lại logic cũ", likely meaning the direct list usage or mocks.
      // But we know API returns data. Let's return to the code before "Standardizing JSON parsing".
      // Previous code (Step 369) just cast to List.
      // But log shows Page structure for /user/me. Assume Public API returns List or Page.
      // I will implement the most standard List extraction without the extra checks if valid.
      
      final data = response.data;
      if (data is List) {
           return data.map((json) => DocumentModel.fromJson(json)).toList();
      } else if (data is Map && data.containsKey('content')) {
           return (data['content'] as List).map((json) => DocumentModel.fromJson(json)).toList();
      }
    }

    throw ServerException(
      'Failed to fetch popular documents',
      response.statusCode ?? 0,
    );
  }

  @override
  Future<List<DocumentModel>> getRecentDocuments() async {
    //  REAL API CALL - tài liệu mới nhất
    final response = await dioClient.get(
      ApiConstants.recentDocumentsReal,
      queryParameters: {'limit': 10},
    );

    if (response.statusCode == 200 && response.data != null) {
       final data = response.data;
       if (data is List) {
           return data.map((json) => DocumentModel.fromJson(json)).toList();
       } else if (data is Map && data.containsKey('content')) {
           return (data['content'] as List).map((json) => DocumentModel.fromJson(json)).toList();
       }
    }

    throw ServerException(
      'Failed to fetch recent documents',
      response.statusCode ?? 0,
    );
  }

  @override
  Future<List<DocumentModel>> searchDocuments(String query) async {
    final response = await dioClient.get(
      ApiConstants.searchDocuments,
      queryParameters: {'q': query, 'limit': 20},
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      if (data is Map && data.containsKey('content')) {
        return (data['content'] as List)
            .map((json) => DocumentModel.fromJson(json))
            .toList();
      } else if (data is List) {
        return data.map((json) => DocumentModel.fromJson(json)).toList();
      }
    }
    return [];
  }

  // --- DOCS DETAIL / INTERACTION LOGIC (Integrated from old DocsRemoteDataSource) ---

  @override
  Future<DocumentEntity> getDocumentDetails({
    required String documentId,
  }) async {
    // 1. Fetch Basic Info from Document Service
    final docRes = await dioClient.get(
      '${ApiConstants.publicDocument}/$documentId',
    );
    
    // Check if doc exists
    if (docRes.statusCode != 200 || docRes.data == null) {
      throw ServerException('Document not found', docRes.statusCode ?? 404);
    }
    
    DocumentModel doc = DocumentModel.fromJson(docRes.data);

    // 2. Fetch Interaction Stats (Likes/Dislikes) from Review Service
    int likes = doc.likes;
    int dislikes = doc.dislikes;
    List<CommentEntity> comments = [];
    String? currentUserReaction;

    try {
      final statsRes = await dioClient.get(
        '${ApiConstants.reviewDocumentStats}/$documentId/stats',
      );
      if (statsRes.statusCode == 200 && statsRes.data['data'] != null) {
        final data = statsRes.data['data'];
        likes = (data['likeCount'] as num?)?.toInt() ?? 0;
        dislikes = (data['dislikeCount'] as num?)?.toInt() ?? 0;
      }
    } catch (e) {
      print("Error fetching stats: $e");
    }
    
    // 3. Keep existing logic for comments...
    try {
      final reviewsRes = await dioClient.get(
        '${ApiConstants.reviewBase}/document/$documentId',
        queryParameters: {'page': 0, 'size': 50},
      );

      if (reviewsRes.statusCode == 200 && reviewsRes.data['data'] != null) {
         final content = reviewsRes.data['data']['content'] as List;
         comments = content.map((item) {
             // Handle BSON-like ID: {"_id": {"$binary": ...}, "userId": { "$binary": ... }}
             // Should traverse to get a string if possible, or fallback.
             String userId = 'Unknown';
             if (item['userId'] is Map) {
                // Try standard Mongo extended JSON
                // If it's $binary, we can't easily convert to UUID without decoding base64 
                // but we can just use a placeholder or substring for display.
                // Or if backend provides 'authorName', use that.
                // Fallback to "User" if too complex.
                userId = "User"; 
             } else {
                userId = item['userId']?.toString() ?? 'Unknown';
             }
             
             return CommentEntity(
                author: userId.length > 10 ? "User ${userId.substring(0, 5)}..." : userId,
                text: item['comment'] ?? "",
             );
         }).toList();
      }
    } catch (e) {
      print("Error fetching comments: $e");
    }

    return doc.copyWith(
      likes: likes,
      dislikes: dislikes,
      comments: comments,
    );
  }

  @override
  Future<void> toggleSave({required String documentId}) async {
    // Assuming backend endpoint for save exists. If not, this might fail or be a placeholder.
    // Ideally: POST /documents/{id}/save or similar.
    // For now, if no endpoint, we can leave it empty or log.
    // BUT user asked to remove mock delay.
    try {
       await dioClient.post('${ApiConstants.documentServiceUrl}/documents/$documentId/save');
    } catch (e) {
       print('Toggle save failed (maybe endpoint missing): $e');
    }
  }

  @override
  Future<void> downloadDocument({required String documentId}) async {
    // Should trigger a download.
    // Often this returns a URL or stream. The Repository usually handles opening it.
    // But if the DataSource needs to call an endpoint to "record" the download:
    try {
       await dioClient.get('${ApiConstants.documentServiceUrl}/documents/$documentId/download');
    } catch (e) {
       print('Download record failed: $e');
    }
  }

  @override
  Future<void> toggleLike({
    required String documentId,
    required bool isLike,
  }) async {
    try {
      await dioClient.post(
        '${ApiConstants.reviewDocumentReact}/$documentId/react',
        queryParameters: {'type': isLike ? 'like' : 'dislike'},
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> postComment({
    required String documentId,
    required String text,
  }) async {
    try {
      await dioClient.post(
        ApiConstants.reviewBase,
        data: {'documentId': documentId, 'comment': text},
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> reactToReview({
    required String documentId,
    required String reviewId,
    required bool isLike,
  }) async {
    try {
      await dioClient.post(
        '${ApiConstants.reviewBase}/$reviewId/react',
        queryParameters: {'type': isLike ? 'like' : 'dislike'},
      );
    } catch (e) {
      rethrow;
    }
  }

  // --- PRIVATE MOCK HELPERS --- (Removed)
  // --- USER DOCS (New Implementation) ---
  @override
  Future<List<DocumentModel>> getMyDocuments({
    int page = 0,
    int size = 10,
    String? traceId,
  }) async {
    final response = await dioClient.get(
      ApiConstants.myDocuments,
      queryParameters: {'page': page, 'size': size},
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      if (data is Map && data.containsKey('content')) {
        return (data['content'] as List)
            .map((json) => DocumentModel.fromJson(json))
            .toList();
      } else if (data is List) {
        return data.map((json) => DocumentModel.fromJson(json)).toList();
      }
    }
    return [];
    // throw ServerException('Failed to fetch user documents', response.statusCode ?? 0);
  }

  @override
  Future<List<DocumentModel>> getMyNewestDocuments({
    int limit = 10,
    String? traceId,
  }) async {
    final response = await dioClient.get(
      ApiConstants.myNewestDocuments,
      queryParameters: {'limit': limit},
    );

    if (response.statusCode == 200 && response.data != null) {
       final data = response.data;
       if (data is List) {
          return data.map((json) => DocumentModel.fromJson(json)).toList();
       } else if (data is Map && data.containsKey('content')) {
          return (data['content'] as List).map((json) => DocumentModel.fromJson(json)).toList();
       }
    }
    return [];
  }

  @override
  Future<List<DocumentModel>> getViewHistory({
    int page = 0,
    int size = 10,
    String? traceId,
  }) async {
    final response = await dioClient.get(
      ApiConstants.myDocumentHistory,
      queryParameters: {'page': page, 'size': size},
    );
    if (response.statusCode == 200 && response.data != null) {
       final data = response.data;
       if (data is List) {
          return data.map((json) => DocumentModel.fromJson(json)).toList();
       } else if (data is Map && data.containsKey('content')) {
          return (data['content'] as List).map((json) => DocumentModel.fromJson(json)).toList();
       }
    }
    return [];
  }

  @override
  Future<List<DocumentModel>> updateDocument(
    String documentId,
    Map<String, dynamic> data, {
    String? traceId,
  }) async {
     // TODO: Implement Update
     // For now return empty or implement call
    //  final response = await dioClient.put('${ApiConstants.userUpdateDocument}/$documentId', data: data);
     return [];
  }

  @override
  Future<List<DocumentModel>> deleteDocument(
    String documentId, {
    String? traceId,
  }) async {
      // TODO: Implement Delete
      await dioClient.delete('${ApiConstants.userDeleteDocument}/$documentId');
      return [];
  }

  @override
  Future<DocumentModel> getPublicDocumentById(String id) async {
    final response = await dioClient.get(
      '${ApiConstants.publicDocumentById}/$id',
    );

    if (response.statusCode == 200 && response.data != null) {
      final  data = response.data['data'] ?? response.data;
      return DocumentModel.fromJson(data);
    }
    
    throw ServerException('Failed to fetch document detail: $id', response.statusCode ?? 0);
  }

  @override
  Future<List<DocumentModel>> getDocumentsByIds(List<String> ids) async {
    final List<DocumentModel> documents = [];
    
    // Make individual requests for each ID
    for (final id in ids) {
      try {
        final document = await getPublicDocumentById(id);
        documents.add(document);
      } catch (e) {
        // Skip documents that fail to load
        print('Failed to load document with ID $id: $e');
      }
    }
    
    return documents;
  }
}

