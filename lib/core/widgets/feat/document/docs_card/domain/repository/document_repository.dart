/// Repository cho thao tác like, bookmark, download tài liệu.
/// Implement ở Data layer (ví dụ DocumentDatasource).
abstract interface class DocumentRepository {
  Future<String?> like(String documentId);
  Future<String?> bookmark(String documentId);
  Future<String?> download(String documentId);
}
