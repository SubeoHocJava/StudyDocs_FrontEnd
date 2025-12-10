import '../../../docs/domain/entity/document_entity.dart';

abstract class DocsRepository {
  Future<DocumentEntity> getDocumentDetails();
  Future<void> toggleSave();
  Future<void> downloadDocument();
  Future<void> toggleLike({required bool isLike}); // true = like, false = dislike
  Future<void> postComment(String text);
}