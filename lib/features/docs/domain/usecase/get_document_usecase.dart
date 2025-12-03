import '../entity/document_entity.dart';
import '../repository/docs_repository.dart';

/// Use Case: lấy thông tin chi tiết tài liệu.
/// Chỉ gọi repository, không xử lý logic UI hay logic framework.
class GetDocumentUseCase {
  final DocsRepository repository;

  GetDocumentUseCase(this.repository);

  /// Thực thi use case bằng cách gọi repository.
  Future<DocumentEntity> call() async {
    return await repository.getDocumentDetails();
  }
}
