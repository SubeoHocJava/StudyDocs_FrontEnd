
import '../data/subject_library_repository.dart';
import '../entity/CommentEntity.dart';
import '../entity/DocumentEntity.dart';


//
// 1️⃣ Search Documents
//
class SearchDocumentsUseCase {
  final SubjectLibraryRepository repository;

  SearchDocumentsUseCase({required this.repository});

  Future<List<DocumentEntity>> call(String query) async {
    return await repository.searchDocuments(query);
  }
}

//
// 2️⃣ Like Document
//
class LikeDocumentUseCase {
  final SubjectLibraryRepository repository;

  LikeDocumentUseCase({required this.repository});

  Future<void> call(String documentId) async {
    return await repository.likeDocument(documentId);
  }
}

//
// 3️⃣ Get Comments
//
class GetCommentsUseCase {
  final SubjectLibraryRepository repository;

  GetCommentsUseCase({required this.repository});

  Future<List<CommentEntity>> call(String documentId) async {
    return await repository.getComments(documentId);
  }
}

//
// 4️⃣ Download Document
//
class DownloadDocumentUseCase {
  final SubjectLibraryRepository repository;

  DownloadDocumentUseCase({required this.repository});

  Future<String> call(String documentId) async {
    return await repository.downloadDocument(documentId);
  }
}

//
// 5️⃣ Bookmark Document
//
class BookmarkDocumentUseCase {
  final SubjectLibraryRepository repository;

  BookmarkDocumentUseCase({required this.repository});

  Future<void> call(String documentId) async {
    return await repository.bookmarkDocument(documentId);
  }
}
