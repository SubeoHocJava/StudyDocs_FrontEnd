import '../repository/docs_repository.dart';

class PostCommentUseCase {
  final DocsRepository repository;

  PostCommentUseCase(this.repository);

  Future<void> call({required String documentId, required String text}) async {
    await repository.postComment(documentId, text);
  }
}