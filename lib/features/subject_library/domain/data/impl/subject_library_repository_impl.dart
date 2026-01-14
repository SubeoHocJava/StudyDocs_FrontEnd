import 'package:studydocs/data/datasource/academic_remote_datasource.dart';
import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import '../../ui_model/CommentEntity.dart';
import '../../ui_model/doc_subject_lib_ui.dart';
import '../subject_library_repository.dart';

class SubjectLibraryRepositoryImpl implements SubjectLibraryRepository {
  final DocumentRemoteDataSource documentDataSource;

  SubjectLibraryRepositoryImpl({required this.documentDataSource});

  @override
  Future<List<DocumentSubjectLibUI>> searchDocuments(String query) async {
    try {
      final models = await documentDataSource.searchDocuments(query);

      return models.map<DocumentSubjectLibUI>((item) {
        return DocumentSubjectLibUI(
          id: item.id,
          title: item.title,
          category: item.category ?? 'General',
          institution: item.institution ?? 'Unknown School',
          pages: item.pageCount ?? 0,
          createdAt: item.createdAt ?? '',
          likesCount: item.viewCount ?? 0, // Using viewCount as mock likes
          commentsCount: item.commentsCount ?? 0,
          thumbnailUrl: null,
          isLiked: false,
          isSaved: false,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> likeDocument(String documentId) async {
    await documentDataSource.toggleLike(documentId: documentId, isLike: true);
  }

  @override
  Future<List<CommentEntity>> getComments(String documentId) async {
    try {
      final entity = await documentDataSource.getDocumentDetails(documentId: documentId);
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
    await documentDataSource.downloadDocument(documentId: documentId);
    return ""; // Mock path
  }

  @override
  Future<void> bookmarkDocument(String documentId) async {
    await documentDataSource.toggleSave(documentId: documentId);
  }
}
