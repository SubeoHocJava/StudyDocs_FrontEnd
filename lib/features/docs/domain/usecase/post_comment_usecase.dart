import '../repository/docs_repository.dart';

class PostCommentUseCase {
  final DocsRepository repository;

  PostCommentUseCase(this.repository);

  Future<void> call(String docId, String text) async {
    await repository.postComment(docId, text);
  Future<void> call({required String documentId, required String text}) async {
    await repository.postComment(documentId: documentId, text: text);
  }
}