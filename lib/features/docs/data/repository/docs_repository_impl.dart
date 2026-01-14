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

    return doc.copyWith(
      likes: (stats['likeCount'] as num?)?.toInt() ?? 0,
      dislikes: (stats['dislikeCount'] as num?)?.toInt() ?? 0,
      currentUserReaction: reaction,
      comments: reviews,
    );
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
