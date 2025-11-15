import '../entity/document_entity.dart';

abstract class HomeRepository {
  Future<List<DocumentEntity>> getDocuments();
  Future<List<DocumentEntity>> getPopularDocuments();
  Future<List<DocumentEntity>> getRecentDocuments();
  Future<List<DocumentEntity>> searchDocuments(String query);
}