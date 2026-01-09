import '../domain/repository/docs_repository.dart';

class ToggleLikeUseCase {
  final DocsRepository repository;

  ToggleLikeUseCase(this.repository);

  Future<void> call({required bool isLike}) async {
    await repository.toggleLike(isLike: isLike);
  }
}