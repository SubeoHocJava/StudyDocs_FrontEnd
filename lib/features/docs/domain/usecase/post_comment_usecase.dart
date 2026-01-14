import '../repository/docs_repository.dart';

class PostCommentUseCase {
  final DocsRepository repository;

  PostCommentUseCase(this.repository);

  Future<void> call(String docId, String text) async {
    await repository.postComment(docId, text);
  }
}