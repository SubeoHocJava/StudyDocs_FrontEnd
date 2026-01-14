import '../domain/repository/docs_repository.dart';

class ToggleLikeUseCase {
  final DocsRepository repository;

  ToggleLikeUseCase(this.repository);

  Future<void> call(String id, {required bool isLike}) async {
    // Map boolean to 'LIKE' or 'DISLIKE' (or 'UNLIKE' if logic requires)
    // ReviewController.reactToDocument takes 'type' param.
    // Assuming type = 'LIKE' or 'DISLIKE'.
    final type = isLike ? 'LIKE' : 'DISLIKE'; 
    await repository.reactToDocument(id, type);
  }
}