import '../../../docs/domain/entity/document_entity.dart';

abstract class DocsRepository {
  Future<DocumentEntity> getDocumentDetails({required String documentId});
  Future<void> toggleSave({required String documentId});
  Future<void> downloadDocument({required String documentId});
  Future<void> toggleLike({required String documentId, required bool isLike});
  Future<void> postComment({required String documentId, required String text});
  Future<void> reactToReview({
    required String documentId,
    required String reviewId,
    required bool isLike,
  });
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
}