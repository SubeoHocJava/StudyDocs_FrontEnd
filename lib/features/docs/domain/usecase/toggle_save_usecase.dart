import '../repository/docs_repository.dart';

/// Use Case: đổi trạng thái lưu tài liệu.
class ToggleSaveUseCase {
  final DocsRepository repository;

  ToggleSaveUseCase(this.repository);

  /// Gọi repository để thực thi hành động lưu/huỷ lưu.
  Future<void> call() async {
    await repository.toggleSave();
  }
}
