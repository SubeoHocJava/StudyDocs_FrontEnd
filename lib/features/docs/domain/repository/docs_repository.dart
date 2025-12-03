import '../entity/document_entity.dart';

/// Repository trừu tượng cho module Documents.
abstract class DocsRepository {
  /// Lấy chi tiết tài liệu
  Future<DocumentEntity> getDocumentDetails();

  /// Lưu hoặc bỏ lưu tài liệu
  Future<void> toggleSave();
}
