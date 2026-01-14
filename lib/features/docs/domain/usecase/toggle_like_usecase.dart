import '../repository/docs_repository.dart';

class ToggleLikeUseCase {
  final DocsRepository repository;

  ToggleLikeUseCase(this.repository);

  Future<void> call(String id, {required bool isLike}) async {
    await repository.reactToDocument(id, isLike ? 'LIKE' : 'DISLIKE');
  }
}