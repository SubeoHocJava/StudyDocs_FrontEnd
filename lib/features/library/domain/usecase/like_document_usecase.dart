import '../repository/library_repository.dart';

class LikeDocumentUseCase {
  final LibraryRepository repository;

  LikeDocumentUseCase(this.repository);

  Future<void> call(String documentId) async {
    // TODO: repository.likeDocument(documentId)
  }
}