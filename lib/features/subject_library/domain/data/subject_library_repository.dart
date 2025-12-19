import '../entity/CommentEntity.dart';
import '../entity/DocumentEntity.dart';

abstract class SubjectLibraryRepository {
  Future<List<DocumentEntity>> searchDocuments(String query);

  Future<void> likeDocument(String documentId);

  Future<List<CommentEntity>> getComments(String documentId);

  Future<String> downloadDocument(String documentId);

  Future<void> bookmarkDocument(String documentId);
}