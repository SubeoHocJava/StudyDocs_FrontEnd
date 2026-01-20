import '../../../docs/domain/entity/document_entity.dart';

abstract class DocsManagementRepository {
  Future<List<DocumentEntity>> getMyDocuments();
  Future<List<DocumentEntity>> getAllDocuments();
  Future<void> deleteDocument(String id);
  Future<void> deleteAdminDocument(String id);
  Future<void> updateDocument(String id, DocumentEntity updatedDoc);
  Future<void> updateAdminDocument(String id, DocumentEntity updatedDoc);
  Future<void> uploadDocument(dynamic file, DocumentEntity metadata);
}
