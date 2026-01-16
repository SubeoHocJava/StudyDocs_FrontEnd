import '../repository/docs_repository.dart';

class ToggleLikeUseCase {
  final DocsRepository repository;

  ToggleLikeUseCase(this.repository);

  Future<void> call(String id, {required bool isLike}) async {
    await repository.reactToDocument(id, isLike ? 'LIKE' : 'DISLIKE');
  Future<void> call({required String documentId, required bool isLike}) async {
    await repository.toggleLike(documentId: documentId, isLike: isLike);
  }
}