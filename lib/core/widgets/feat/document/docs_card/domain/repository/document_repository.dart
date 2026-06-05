abstract interface class DocumentRepository {
  Future<String?> like(String documentId);

  Future<String?> bookmark(String documentId);

  Future<String?> download(String documentId);
}
