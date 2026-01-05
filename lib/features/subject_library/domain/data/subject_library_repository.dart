
import '../ui_model/CommentEntity.dart';
import '../ui_model/doc_subject_lib_ui.dart';

abstract class SubjectLibraryRepository {
  Future<List<DocumentSubjectLibUI>> searchDocuments(String query);

  Future<void> likeDocument(String documentId);

  Future<List<CommentEntity>> getComments(String documentId);

  Future<String> downloadDocument(String documentId);

  Future<void> bookmarkDocument(String documentId);
}