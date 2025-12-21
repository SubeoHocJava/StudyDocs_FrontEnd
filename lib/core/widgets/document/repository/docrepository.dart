abstract class DocumentRepository {
  /// Download document by id
  Future<void> download(String documentId);

  /// Save / bookmark document
  Future<void> save(String documentId);
}