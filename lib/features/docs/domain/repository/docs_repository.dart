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
}