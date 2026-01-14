



import 'package:studydocs/core/constants/review_api_constants.dart' show ReviewApiConstants;
import 'package:studydocs/core/network/dio_client.dart' show DioClient;
import 'package:studydocs/data/datasource/docs_remote_datasource.dart';

import '../../../features/docs/domain/entity/document_entity.dart';

class DocsRemoteDataSourceImpl implements DocsRemoteDataSource {
  final DioClient dioClient;

  // UUID cố định để mô phỏng 1 document cụ thể bên BE
  static const String mockDocumentId = "3fa85f64-5717-4562-b3fc-2c963f66afa6";

  DocsRemoteDataSourceImpl({required this.dioClient});

  // Helper getters for endpoints
  String get _reviewBaseUrl => ReviewApiConstants.baseUrl;

  @override
  Future<DocumentEntity> getDocumentDetails() async {
    // DỮ LIỆU TĨNH (do BE không có Document Service)
    const String cloudUrl = "https://res.cloudinary.com/dzfynkkoc/image/upload/f_jpg,pg_1/rd4commsbz2vbzli4h3z";
    const int totalPages = 5;
    const String fileName = "DeCuongTieuLuan_TranNhutAnh_22130915_09082025.pdf";
    const String downloadUrl = "https://res.cloudinary.com/dzfynkkoc/image/upload/fl_attachment/rd4commsbz2vbzli4h3z";

    List<String> previewUrls = [];
    for (int i = 1; i <= totalPages; i++) {
      previewUrls.add(cloudUrl.replaceAll("pg_1", "pg_$i"));
    }

    // DỮ LIỆU ĐỘNG TỪ REVIEW SERVICE
    int likes = 0;
    int dislikes = 0;
    List<CommentEntity> comments = [];

    try {
      // 1. Get Stats - Use full URL to override default base URL
      final statsRes = await dioClient.get('$_reviewBaseUrl/reviews/document/$mockDocumentId/stats');
      if (statsRes.statusCode == 200 && statsRes.data['data'] != null) {
        final data = statsRes.data['data'];
        likes = data['likeCount'] ?? 0;
        dislikes = data['dislikeCount'] ?? 0;
      }

      // 2. Get Reviews (Comments)
      final reviewsRes = await dioClient.get(
        '$_reviewBaseUrl/reviews/document/$mockDocumentId',
        queryParameters: {'page': 0, 'size': 50},
      );

      if (reviewsRes.statusCode == 200 && reviewsRes.data['data'] != null) {
        final content = reviewsRes.data['data']['content'] as List;
        comments = content.map((item) {
          final userId = item['userId']?.toString() ?? 'Unknown';
          // Giả lập tên user vì BE Review không trả về tên
          final shortId = userId.length > 5 ? userId.substring(0, 5) : userId;
          return CommentEntity(
            author: "User $shortId",
            text: item['comment'] ?? "",
          );
        }).toList();
      }

    } catch (e) {
      print("Lỗi khi fetch data từ BE: $e");
      // Fallback
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
  Future<void> toggleSave() async => await Future.delayed(const Duration(milliseconds: 300));

  @override
  Future<void> downloadDocument() async => await Future.delayed(const Duration(milliseconds: 1000));

  @override
  Future<void> toggleLike({required bool isLike}) async {
    try {
      await dioClient.post(
        '$_reviewBaseUrl/reviews/document/$mockDocumentId/react',
        queryParameters: {'type': isLike ? 'like' : 'dislike'},
      );
    } catch (e) {
      print("Lỗi khi like: $e");
      rethrow;
    }
  }

  @override
  Future<void> postComment(String text) async {
    try {
      await dioClient.post(
        '$_reviewBaseUrl/reviews',
        data: {
          'documentId': mockDocumentId,
          'comment': text,
        },
      );
    } catch (e) {
      print("Lỗi khi comment: $e");
      rethrow;
    }
  }

  @override
  Future<void> reactToReview({required String reviewId, required bool isLike}) async {
    try {
      await dioClient.post(
        '$_reviewBaseUrl/reviews/$reviewId/react',
        queryParameters: {'type': isLike ? 'like' : 'dislike'},
      );
    } catch (e) {
      print("Lỗi khi react review: $e");
      rethrow;
    }
  }
}
