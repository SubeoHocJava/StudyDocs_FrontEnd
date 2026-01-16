import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../services/token_storage_service.dart';
import '../../domain/entity/document_entity.dart';
import '../../domain/repository/docs_repository.dart';
import '../../../../data/datasource/docs_remote_datasource.dart';

class DocsRepositoryImpl implements DocsRepository {
  final DocsRemoteDataSource dataSource;

  DocsRepositoryImpl({required this.dataSource});

  @override
  Future<List<DocumentEntity>> getPublicDocuments({int page = 0, int size = 10}) =>
      dataSource.getPublicDocuments(page: page, size: size);

  @override
  Future<List<DocumentEntity>> getNewestDocuments({int limit = 10}) =>
      dataSource.getNewestDocuments(limit: limit);

  @override
  Future<List<DocumentEntity>> getMostLikedDocuments({int limit = 10}) =>
      dataSource.getMostLikedDocuments(limit: limit);

  @override
  Future<DocumentEntity> getDocumentById(String id) async {
    final results = await Future.wait([
      dataSource.getDocumentById(id),
      dataSource.getDocumentStats(id),
      dataSource.getMyDocumentReaction(id),
      dataSource.getReviewsByDocumentId(id),
    ]);

    final doc = results[0] as DocumentEntity;
    final stats = results[1] as Map<String, dynamic>;
    final reaction = results[2] as String?; // Could be null
    final reviews = results[3] as List<CommentEntity>;

    final enrichedDoc = await _enrichDocument(doc);

    return enrichedDoc.copyWith(
      likes: (stats['likeCount'] as num?)?.toInt() ?? 0,
      dislikes: (stats['dislikeCount'] as num?)?.toInt() ?? 0,
      currentUserReaction: reaction,
      comments: reviews, description: '',
    );
  }

  Future<DocumentEntity> _enrichDocument(DocumentEntity doc) async {
    String? schoolName = doc.school;
    String? courseName = doc.course;

    try {
      // Create Dio instance for Academic Service calls
      // Note: We use a new Dio instance here to avoid modifying the existing dataSource structure.
      // In a cleaner architecture, this should be in a separate RemoteDataSource.
      final dio = Dio(BaseOptions(
        baseUrl: ApiConstants.academicBaseUrl,
        connectTimeout: const Duration(seconds: 10),
      ));

      // Append Token
      final token = await TokenStorageService().getAuthorizationHeader();
      if (token != null) {
        dio.options.headers['Authorization'] = token;
      }

      // Fetch University Name if ID exists and Name is missing/placeholder
      if (doc.universityId != null && (doc.school == 'Unknown School' || doc.school.isEmpty)) {
        try {
          final response = await dio.get('${ApiConstants.academicUniversities}/${doc.universityId}');
          if (response.statusCode == 200 && response.data['data'] != null) {
             schoolName = response.data['data']['name'];
          }
        } catch (e) {
          print('Error fetching university: $e');
        }
      }

      // Fetch Subject Name if ID exists and Name is missing/placeholder
      if (doc.subjectId != null && (doc.course == 'Unknown Course' || doc.course.isEmpty)) {
        try {
           final response = await dio.get('${ApiConstants.academicSubjects}/${doc.subjectId}');
           if (response.statusCode == 200 && response.data['data'] != null) {
             courseName = response.data['data']['name'];
           }
        } catch (e) {
          print('Error fetching subject: $e');
        }
      }

      return doc.copyWith(
        school: schoolName,
        course: courseName,
      );

    } catch (e) {
      print('Error enriching document: $e');
      return doc;
    }
  }

  @override
  Future<void> reactToDocument(String id, String type) =>
      dataSource.reactToDocument(id, type);

  @override
  Future<void> toggleSave(String id) => dataSource.toggleSave(id);

  @override
  Future<void> postComment(String docId, String content) =>
      dataSource.postComment(docId, content);

  @override
  Future<void> reactToReview({required String reviewId, required bool isLike}) =>
      dataSource.reactToReview(reviewId: reviewId, isLike: isLike);

  @override
  Future<void> downloadDocument(String id) async {
    // TODO: Implement actual download logic when backend endpoint is ready
    // For now, we prevent the app from crashing.
    print("Download requested for document: $id. Feature pending backend implementation.");
  }

  @override
  Future<List<CommentEntity>> getReviewsByDocumentId(String docId, {int page = 0, int size = 10}) =>
      dataSource.getReviewsByDocumentId(docId, page: page, size: size);
}
