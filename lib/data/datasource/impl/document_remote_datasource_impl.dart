import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/data/model/api_response.dart';
import 'package:studydocs/data/model/document_model.dart';
import 'package:studydocs/data/model/request/upload_document_request.dart';
import 'package:studydocs/features/docs/domain/entity/document_entity.dart';
import '../document_remote_datasource.dart';

class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
  final DioClient dioClient;

  DocumentRemoteDataSourceImpl({required this.dioClient});

  // --- HOME / LIST LOGIC (Keeping mocks for now) ---

  @override
  Future<DocumentModel> uploadDocument(
    UploadDocumentRequest request,
    File file,
  ) async {
    try {
      final formData = FormData.fromMap({
        'data': jsonEncode(request.toJson()), // Send metadata as JSON string
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await dioClient.post(
        ApiConstants.userUploadDocument,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        final apiResponse = ApiResponse<DocumentModel>.fromJson(
          response.data,
          (json) => DocumentModel.fromJson(json),
        );

        if (apiResponse.isSuccess && apiResponse.data != null) {
          return apiResponse.data!;
        }
      }

      throw ServerException(
        'Failed to upload document',
        response.statusCode ?? 0,
      );
    } catch (e) {
      throw ServerException('Failed to upload document: $e', 0);
    }
  }

  @override
  Future<List<DocumentModel>> getDocuments() async {
    // Mock logic from HomeRemoteDataSource
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockDocuments();
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
    // ✅ REAL API CALL - tài liệu mới nhất
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
    final allDocs = _getMockDocuments();
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

  // --- PRIVATE MOCK HELPERS ---

  List<DocumentModel> _getMockDocuments() {
    return [
      DocumentModel(
        id: '1',
        title: 'Báo Cáo Đồ Án Chuyên Ngành Trang web bán rượu',
        description:
            'Đồ án chuyên ngành về phát triển trang web bán rượu sử dụng công nghệ .NET',
        author: 'Lý Tuấn Dũng, Nguyễn Văn Hảo',
        authorId: 'author1',
        category: 'Lập trình .NET',
        institution: 'Trường Đại học Nông Lâm Tp. HCM',
        pageCount: 19,
        academicYear: '2024/2025',
        viewCount: 1250,
        downloadCount: 320,
        likesCount: 15,
        commentsCount: 3,
        rating: 4.5,
        createdAt:
            DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        fileType: 'PDF',
      ),
      DocumentModel(
        id: '2',
        title: 'Bài giảng Lập Trình Mobile Flutter',
        description: 'Tài liệu hướng dẫn lập trình ứng dụng mobile với Flutter',
        author: 'Trần Thị B',
        authorId: 'author2',
        category: 'Lập trình Mobile',
        institution: 'Trường Đại học Bách Khoa',
        pageCount: 45,
        academicYear: '2024/2025',
        viewCount: 890,
        downloadCount: 245,
        likesCount: 23,
        commentsCount: 5,
        rating: 4.8,
        createdAt:
            DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        fileType: 'PDF',
      ),
    ];
  }

  @override
  Future<List<DocumentModel>> deleteDocument(
    String documentId, {
    String? traceId,
  }) async {
    try {
      await dioClient.delete(
        '${ApiConstants.userDeleteDocument}/$documentId',
      );
      // Sau khi xóa, trả về danh sách mới của user
      return getMyDocuments(traceId: traceId);
    } catch (e) {
      throw ServerException('Failed to delete document', 0);
    }
  }

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
      // Nếu API trả về Page object (có content)
      if (data is Map<String, dynamic> && data.containsKey('content')) {
        final List<dynamic> content = data['content'];
        return content.map((json) => DocumentModel.fromJson(json)).toList();
      }
      // Nếu API trả về List trực tiếp
      if (data is List) {
        return data.map((json) => DocumentModel.fromJson(json)).toList();
      }
    }

    throw ServerException('Failed to fetch my documents', response.statusCode);
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
       // Nếu API trả về Page object (có content)
      if (data is Map<String, dynamic> && data.containsKey('content')) {
        final List<dynamic> content = data['content'];
        return content.map((json) => DocumentModel.fromJson(json)).toList();
      }
      if (data is List) {
        return data.map((json) => DocumentModel.fromJson(json)).toList();
      }
    }

    throw ServerException(
      'Failed to fetch newest documents',
      response.statusCode,
    );
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
      if (data is Map<String, dynamic> && data.containsKey('content')) {
        final List<dynamic> content = data['content'];
        return content.map((json) => DocumentModel.fromJson(json)).toList();
      }
      if (data is List) {
        return data.map((json) => DocumentModel.fromJson(json)).toList();
      }
    }

    throw ServerException('Failed to fetch view history', response.statusCode);
  }

  @override
  Future<List<DocumentModel>> updateDocument(
    String documentId,
    Map<String, dynamic> data, {
    String? traceId,
  }) async {
    try {
      await dioClient.patch(
        '${ApiConstants.userUpdateDocument}/$documentId',
        data: data,
      );
      // Sau khi update, trả về danh sách mới của user
      return getMyDocuments(traceId: traceId);
    } catch (e) {
       throw ServerException('Failed to update document', 0);
    }
  }



}
