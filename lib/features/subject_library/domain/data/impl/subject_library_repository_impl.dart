import 'package:studydocs/data/datasource/docs_remote_datasource.dart';
import '../../ui_model/CommentEntity.dart';
import '../../ui_model/doc_subject_lib_ui.dart';
import '../subject_library_repository.dart';

class SubjectLibraryRepositoryImpl implements SubjectLibraryRepository {
  final DocsRemoteDataSource documentDataSource;

  SubjectLibraryRepositoryImpl({required this.documentDataSource});

  @override
  Future<List<DocumentSubjectLibUI>> searchDocuments(String query) async {
    try {
      final models = await documentDataSource.searchDocuments(query);

      return models.map<DocumentSubjectLibUI>((item) {
        return DocumentSubjectLibUI(
          id: item.id ?? '', // Handle nullable
          title: item.title,
          category: item.course, // Map course to category
          institution: item.school, // Map school to institution
          pages: item.pages,
          createdAt: item.year, // Using year as created at placeholder
          likesCount: item.likes,
          commentsCount: item.comments.length, // Approximate
          thumbnailUrl: item.previewUrls.isNotEmpty ? item.previewUrls.first : null,
          isLiked: false, 
          isSaved: item.isSaved,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> likeDocument(String documentId) async {
    await documentDataSource.reactToDocument(documentId, 'LIKE');
  }

  @override
  Future<List<CommentEntity>> getComments(String documentId) async {
    try {
      final entity = await documentDataSource.getDocumentById(documentId);
      return entity.comments.map((e) => CommentEntity(
        id: '',
        username: e.author,
        avatarUrl: null,
        content: e.text,
        createdAt: '',
      )).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String> downloadDocument(String documentId) async {
    await documentDataSource.downloadDocument(documentId);
    return ""; // Mock path
  }

  @override
  Future<void> bookmarkDocument(String documentId) async {
    await documentDataSource.toggleSave(documentId);
  }
}
