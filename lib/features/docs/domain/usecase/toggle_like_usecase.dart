import '../repository/docs_repository.dart';

class ToggleLikeUseCase {
  final DocsRepository repository;

  ToggleLikeUseCase(this.repository);

  // Changed to support generic reaction type (LIKE/DISLIKE)
  Future<void> call({required String documentId, required String reactionType}) async {
    await repository.reactToDocument(documentId, reactionType);
  }
}
