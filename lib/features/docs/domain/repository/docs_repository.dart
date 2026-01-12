import '../entity/document_entity.dart';

abstract class DocsRepository {
  Future<List<DocumentEntity>> getPublicDocuments({int page = 0, int size = 10});
  Future<List<DocumentEntity>> getNewestDocuments({int limit = 10});
  Future<List<DocumentEntity>> getMostLikedDocuments({int limit = 10});
  Future<DocumentEntity> getDocumentById(String id);
  Future<void> reactToDocument(String id, String type);
}