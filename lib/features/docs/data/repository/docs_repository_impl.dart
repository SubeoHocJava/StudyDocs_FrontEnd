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
    // Execute fetches in parallel, but handle errors individually
    final results = await Future.wait([
      dataSource.getDocumentById(id),
      dataSource.getDocumentStats(id).catchError((_) => <String, dynamic>{}),
      dataSource.getMyDocumentReaction(id).catchError((_) => null),
      dataSource.getReviewsByDocumentId(id).catchError((_) => <CommentEntity>[]),
    ]);

    var doc = results[0] as DocumentEntity;
    final stats = results[1] as Map<String, dynamic>;
    final reaction = results[2] as String?; 
    final reviews = results[3] as List<CommentEntity>;

    // Attach reviews so they can be enriched with author names
    doc = doc.copyWith(comments: reviews);

    // Enrich document (school/subject name, uploader name, comment author names)
    final enrichedDoc = await _enrichDocument(doc);

    return enrichedDoc.copyWith(
      likes: (stats['likeCount'] as num?)?.toInt() ?? 0,
      dislikes: (stats['dislikeCount'] as num?)?.toInt() ?? 0,
      currentUserReaction: reaction,
      // comments: reviews, // MOVED UP: Do not overwrite enriched comments!
      description: doc.description, // Ensure description isn't wiped out
    );
  }

  Future<DocumentEntity> _enrichDocument(DocumentEntity doc) async {
    String? schoolName = doc.school;
    String? courseName = doc.course;
    String? uploaderName = doc.uploader;

    try {
      // Create Dio instance for Academic Service calls
      // Note: We use a new Dio instance here to avoid modifying the existing dataSource structure.
      final dio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl, // Academic service now shares base or relative paths
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
          // Endpoint: /academics/universities/id/{id}
          final response = await dio.get('${AcademicEndpoints.publicUniversityById}/${doc.universityId}');
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
           // Endpoint: /academics/subjects/id/{id}
           final response = await dio.get('${AcademicEndpoints.publicSubjectById}/${doc.subjectId}');
           if (response.statusCode == 200 && response.data['data'] != null) {
             courseName = response.data['data']['name'];
           }
        } catch (e) {
          print('Error fetching subject: $e');
        }
      }

      // Fetch Uploader Name if "Unknown User" or empty, and we have uploaderId
      if (doc.uploaderId != null && (doc.uploader == 'Unknown User' || doc.uploader.isEmpty)) {
        try {
           final userDio = Dio(BaseOptions(
             baseUrl: ApiConstants.baseUrl, // Use main API base URL
             connectTimeout: const Duration(seconds: 10),
           ));
           
           if (token != null) {
             userDio.options.headers['Authorization'] = token;
           }

           final response = await userDio.get(
             UserEndpoints.getById,
             queryParameters: {'id': doc.uploaderId},
           );

           if (response.statusCode == 200 && response.data != null) {
              final root = response.data;
              // Extract inner data if wrapped
              final userData = (root is Map && root.containsKey('data')) ? root['data'] : root;

              if (userData is Map) {
                  final name = userData['fullName'] ?? 
                               userData['userName'] ?? 
                               userData['uploadName'] ??
                               (userData['firstName'] != null ? "${userData['firstName']} ${userData['lastName'] ?? ''}".trim() : null);
                  
                  if (name != null) {
                     uploaderName = name;
                  }
              }
           }
        } catch (e) {
          print('Error fetching uploader: $e');
        }
      }


      
      // Enrich Comments (fetch author names)
      // Use the helper method now
      List<CommentEntity> enrichedComments = await _enrichCommentAuthors(doc.comments);

      return doc.copyWith(
        school: schoolName,
        course: courseName,
        uploader: uploaderName,
        comments: enrichedComments,
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
    print("Download requested for document: $id. Feature pending backend implementation.");
  }

  @override
  Future<List<CommentEntity>> getReviewsByDocumentId(String docId, {int page = 0, int size = 10}) async {
    final comments = await dataSource.getReviewsByDocumentId(docId, page: page, size: size);
    return _enrichCommentAuthors(comments);
  }

  Future<List<CommentEntity>> _enrichCommentAuthors(List<CommentEntity> comments) async {
    if (comments.isEmpty) return comments;

    try {
      final userDio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
      ));

      final token = await TokenStorageService().getAuthorizationHeader();
      if (token != null) {
        userDio.options.headers['Authorization'] = token;
      }

      final userIdsToFetch = comments
          .map((c) => c.authorId)
          .where((id) => id != null && id.isNotEmpty)
          .toSet();

      final Map<String, String> userNameCache = {};

      for (final userId in userIdsToFetch) {
        if (userId == null) continue;
        try {
          final response = await userDio.get(
            UserEndpoints.getById,
            queryParameters: {'id': userId},
          );
          if (response.statusCode == 200 && response.data != null) {
            final root = response.data;
            final userData = (root is Map && root.containsKey('data')) ? root['data'] : root;

            if (userData is Map) {
              final name = userData['fullName'] ??
                  userData['userName'] ??
                  userData['uploadName'] ??
                  (userData['firstName'] != null ? "${userData['firstName']} ${userData['lastName'] ?? ''}".trim() : null);
              if (name != null) {
                userNameCache[userId] = name;
              }
            }
          }
        } catch (e) {
          // Ignore
        }
      }

      return comments.map((comment) {
        if (comment.authorId != null && userNameCache.containsKey(comment.authorId)) {
          return comment.copyWith(author: userNameCache[comment.authorId]);
        }
        return comment;
      }).toList();
    } catch (e) {
      print('Error enriching comments: $e');
      return comments;
    }
  }
}
