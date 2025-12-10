import '../repository/docs_repository.dart';

class ToggleSaveUseCase {
  final DocsRepository repository;

  ToggleSaveUseCase(this.repository);

  /// Gọi repository để thực thi hành động lưu/huỷ lưu.
  Future<void> call() async {
    await repository.toggleSave();
  }
}
