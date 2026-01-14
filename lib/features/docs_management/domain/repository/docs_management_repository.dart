import 'dart:io';
import '../../../docs/domain/entity/document_entity.dart';

abstract class DocsManagementRepository {
  Future<List<DocumentEntity>> getMyDocuments();
  Future<void> deleteDocument(String id);
  Future<void> updateDocument(String id, DocumentEntity updatedDoc);
  Future<void> uploadDocument(dynamic file, DocumentEntity metadata);
}
