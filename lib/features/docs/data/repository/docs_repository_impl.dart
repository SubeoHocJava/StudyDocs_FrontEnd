import 'package:dio/dio.dart';
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../services/token_storage_service.dart';
import '../../domain/entity/document_entity.dart';
import '../../domain/repository/docs_repository.dart';
import '../../../../data/datasource/docs_remote_datasource.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../data/datasource/asset_remote_datasource.dart';
import '../../../../data/datasource/impl/asset_remote_datasource_impl.dart';
import '../../../../data/datasource/impl/user_remote_datasource_impl.dart';

class DocsRepositoryImpl implements DocsRepository {
  final DocsRemoteDataSource dataSource;

  late final UserRemoteDataSource userRemoteDataSource;
  late final AssetRemoteDataSource assetRemoteDataSource;

  DocsRepositoryImpl({required this.dataSource}) {
    final dioClient = DioClient();

    assetRemoteDataSource =
        AssetRemoteDataSourceImpl(dioClient: dioClient);

    userRemoteDataSource = UserDataSourceImpl(
      dioClient: dioClient,
      assetRemoteDataSource: assetRemoteDataSource,
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // LOAD DOCUMENT LIST
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  Future<List<DocumentEntity>> getPublicDocuments({
    int page = 0,
    int size = 10,
  }) =>
      dataSource.getPublicDocuments(page: page, size: size);

  @override
  Future<List<DocumentEntity>> getNewestDocuments({int limit = 10}) =>
      dataSource.getNewestDocuments(limit: limit);

  @override
  Future<List<DocumentEntity>> getMostLikedDocuments({int limit = 10}) =>
      dataSource.getMostLikedDocuments(limit: limit);

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // DOCUMENT DETAIL
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  Future<DocumentEntity> getDocumentById(String id) async {
    final results = await Future.wait([
      dataSource.getDocumentById(id),
      dataSource.getDocumentStats(id).catchError((_) => <String, dynamic>{}),
      dataSource.getMyDocumentReaction(id).catchError((_) => null),
      dataSource
          .getReviewsByDocumentId(id)
          .catchError((_) => <CommentEntity>[]),
    ]);

    var doc = results[0] as DocumentEntity;
    final stats = results[1] as Map<String, dynamic>;
    final reaction = results[2] as String?;
    final reviews = results[3] as List<CommentEntity>;

    doc = doc.copyWith(comments: reviews);

    final enrichedDoc = await _enrichDocument(doc);

    return enrichedDoc.copyWith(
      likes: (stats['likeCount'] as num?)?.toInt() ?? 0,
      dislikes: (stats['dislikeCount'] as num?)?.toInt() ?? 0,
      currentUserReaction: reaction,
      description: doc.description,
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // ENRICH DOCUMENT
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Future<DocumentEntity> _enrichDocument(DocumentEntity doc) async {
    String? schoolName = doc.school;
    String? courseName = doc.course;
    String? uploaderName = doc.uploader;

    try {
      final dio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
      ));

      final token = await TokenStorageService().getAuthorizationHeader();
      if (token != null) {
        dio.options.headers['Authorization'] = token;
      }

      // University
      if (doc.universityId != null &&
          (doc.school.isEmpty || doc.school == 'Unknown School')) {
        try {
          final res = await dio.get(
            '${AcademicEndpoints.publicUniversityById}/${doc.universityId}',
          );
          schoolName = res.data?['data']?['name'] ?? schoolName;
        } catch (_) {}
      }

      // Subject
      if (doc.subjectId != null &&
          (doc.course.isEmpty || doc.course == 'Unknown Course')) {
        try {
          final res = await dio.get(
            '${AcademicEndpoints.publicSubjectById}/${doc.subjectId}',
          );
          courseName = res.data?['data']?['name'] ?? courseName;
        } catch (_) {}
      }

      // Uploader
      if (doc.uploaderId != null &&
          (doc.uploader.isEmpty || doc.uploader == 'Unknown User')) {
        try {
          final res = await dio.get(
            UserEndpoints.getById,
            queryParameters: {'id': doc.uploaderId},
          );

          final data = res.data?['data'];
          if (data is Map) {
            uploaderName = data['fullName'] ??
                data['userName'] ??
                data['uploadName'] ??
                uploaderName;
          }
        } catch (_) {}
      }

      final enrichedComments = await _enrichCommentAuthors(doc.comments);

      return doc.copyWith(
        school: schoolName,
        course: courseName,
        uploader: uploaderName,
        comments: enrichedComments,
      );
    } catch (_) {
      return doc;
    }
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // USER ACTIONS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  Future<void> reactToDocument(String id, String type) =>
      dataSource.reactToDocument(id, type);

  /// ✅ SAVE DOCUMENT (GIỐNG LIBRARY)
  @override
  Future<void> toggleSave(String id) async {
    await userRemoteDataSource.saveDocument(id);
  }

  @override
  Future<void> postComment(String docId, String content) =>
      dataSource.postComment(docId, content);

  @override
  Future<void> reactToReview({
    required String reviewId,
    required bool isLike,
  }) =>
      dataSource.reactToReview(reviewId: reviewId, isLike: isLike);

  @override
  Future<void> downloadDocument(String id) async {
    print('Download document $id');
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // COMMENTS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  Future<List<CommentEntity>> getReviewsByDocumentId(
      String docId, {
        int page = 0,
        int size = 10,
      }) async {
    final comments =
    await dataSource.getReviewsByDocumentId(docId, page: page, size: size);
    return _enrichCommentAuthors(comments);
  }

  Future<List<CommentEntity>> _enrichCommentAuthors(
      List<CommentEntity> comments) async {
    if (comments.isEmpty) return comments;

    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
    ));

    final token = await TokenStorageService().getAuthorizationHeader();
    if (token != null) {
      dio.options.headers['Authorization'] = token;
    }

    final ids = comments
        .map((e) => e.authorId)
        .where((e) => e != null && e.isNotEmpty)
        .toSet();

    final Map<String, String> cache = {};

    for (final id in ids) {
      try {
        final res = await dio.get(
          UserEndpoints.getById,
          queryParameters: {'id': id},
        );
        final data = res.data?['data'];
        if (data is Map) {
          final name = data['fullName'] ??
              data['userName'] ??
              data['uploadName'];
          if (name != null) cache[id!] = name;
        }
      } catch (_) {}
    }

    return comments.map((c) {
      if (c.authorId != null && cache.containsKey(c.authorId)) {
        return c.copyWith(author: cache[c.authorId]);
      }
      return c;
    }).toList();
  }

@override
  Future<void> deleteDocument(String id) => dataSource.deleteDocument(id);

  @override
  Future<void> updateDocument(String id, String title, String description, String year) {
    return dataSource.updateDocument(id, {
      'title': title,
      'description': description,
      'schoolYear': year,
    });
  }
}
