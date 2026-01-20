import '../../../docs/domain/entity/document_entity.dart';

abstract class DocsRepository {
  Future<List<DocumentEntity>> getPublicDocuments({int page = 0, int size = 10});
  Future<List<DocumentEntity>> getNewestDocuments({int limit = 10});
  Future<List<DocumentEntity>> getMostLikedDocuments({int limit = 10});
  Future<DocumentEntity> getDocumentById(String id);
  Future<void> reactToDocument(String id, String type);
  Future<void> toggleSave(String id);
  Future<void> postComment(String docId, String content);
  Future<void> reactToReview({required String reviewId, required bool isLike});
  Future<void> downloadDocument(String id);
  Future<List<CommentEntity>> getReviewsByDocumentId(String docId, {int page = 0, int size = 10});
  Future<void> deleteDocument(String id);
  Future<void> updateDocument(String id, String title, String description, String year);
}
