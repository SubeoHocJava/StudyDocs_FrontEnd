import 'package:studydocs/core/exceptions/api_exception.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/data/model/document_model.dart';
import 'package:studydocs/features/docs/domain/entity/document_entity.dart';
import '../document_remote_datasource.dart';

class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
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
      final List<dynamic> data = response.data;
      return data.map((json) => DocumentModel.fromJson(json)).toList();
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
      final List<dynamic> data = response.data;
      return data.map((json) => DocumentModel.fromJson(json)).toList();
    }

    throw ServerException(
      'Failed to fetch recent documents',
      response.statusCode ?? 0,
    );
  }

  @override
  Future<List<DocumentModel>> searchDocuments(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final allDocs = null;
    final lowerQuery = query.toLowerCase();
    return allDocs.where((doc) {
      return doc.title.toLowerCase().contains(lowerQuery) ||
          (doc.description?.toLowerCase().contains(lowerQuery) ?? false) ||
          (doc.category?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  // --- DOCS DETAIL / INTERACTION LOGIC (Integrated from old DocsRemoteDataSource) ---

  // UUID cố định để mô phỏng 1 document cụ thể bên BE (từ design cũ)
  static const String mockDocumentId = "3fa85f64-5717-4562-b3fc-2c963f66afa6";

  @override
  Future<DocumentEntity> getDocumentDetails({
    required String documentId,
  }) async {
    // DỮ LIỆU TĨNH (do BE không có Document Service)
    const String cloudUrl =
        "https://res.cloudinary.com/dzfynkkoc/image/upload/f_jpg,pg_1/rd4commsbz2vbzli4h3z";
    const int totalPages = 5;
    const String fileName = "DeCuongTieuLuan_TranNhutAnh_22130915_09082025.pdf";
    const String downloadUrl =
        "https://res.cloudinary.com/dzfynkkoc/image/upload/fl_attachment/rd4commsbz2vbzli4h3z";

    List<String> previewUrls = [];
    for (int i = 1; i <= totalPages; i++) {
      previewUrls.add(cloudUrl.replaceAll("pg_1", "pg_$i"));
    }

    // DỮ LIỆU ĐỘNG TỪ REVIEW SERVICE
    int likes = 0;
    int dislikes = 0;
    List<CommentEntity> comments = [];

    try {
      // Sử dụng documentId được truyền vào hoặc fallback mockDocumentId
      final targetId = documentId.isEmpty ? mockDocumentId : documentId;

      // 1. Get Stats (Review Service)
      final statsRes = await dioClient.get(
        '${ApiConstants.reviewBaseUrl}/reviews/document/$targetId/stats',
      );
      if (statsRes.statusCode == 200 && statsRes.data['data'] != null) {
        final data = statsRes.data['data'];
        likes = data['likeCount'] ?? 0;
        dislikes = data['dislikeCount'] ?? 0;
      }

      // 2. Get Reviews (Comments)
      final reviewsRes = await dioClient.get(
        '${ApiConstants.reviewBaseUrl}/reviews/document/$targetId',
        queryParameters: {'page': 0, 'size': 50},
      );

      if (reviewsRes.statusCode == 200 && reviewsRes.data['data'] != null) {
        final content = reviewsRes.data['data']['content'] as List;
        comments =
            content.map((item) {
              final userId = item['userId']?.toString() ?? 'Unknown';
              final shortId =
                  userId.length > 5 ? userId.substring(0, 5) : userId;
              return CommentEntity(
                author: "User $shortId",
                text: item['comment'] ?? "",
              );
            }).toList();
      }
    } catch (e) {
      print("Lỗi khi fetch data từ Review Service: $e");
    }

    return DocumentEntity(
      title: fileName.replaceAll('.pdf', ''),
      course: "Lập Trình .NET",
      school: "Trường Đại học Nông Lâm Tp. HCM",
      year: "2024/2025",
      uploader: "Subeo Dangiu",
      likes: likes,
      dislikes: dislikes,
      pages: totalPages,
      fileSize: "3.0 MB",
      downloadUrl: downloadUrl,
      previewUrls: previewUrls,
      comments: comments,
    );
  }

  @override
  Future<void> toggleSave({required String documentId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> downloadDocument({required String documentId}) async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Future<void> toggleLike({
    required String documentId,
    required bool isLike,
  }) async {
    final targetId = documentId.isEmpty ? mockDocumentId : documentId;
    try {
      await dioClient.post(
        '${ApiConstants.reviewBaseUrl}/reviews/document/$targetId/react',
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
    final targetId = documentId.isEmpty ? mockDocumentId : documentId;
    try {
      await dioClient.post(
        '${ApiConstants.reviewBaseUrl}/reviews',
        data: {'documentId': targetId, 'comment': text},
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
        '${ApiConstants.reviewBaseUrl}/reviews/$reviewId/react',
        queryParameters: {'type': isLike ? 'like' : 'dislike'},
      );
    } catch (e) {
      rethrow;
    }
  }

  // --- PRIVATE MOCK HELPERS --- (Removed)
}
