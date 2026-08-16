import 'package:studydocs/screens/user/library/domain/entity/library_page_data.dart';
import 'package:studydocs/screens/user/library/domain/entity/library_subject_page_data.dart';
import 'package:studydocs/screens/user/library/domain/repository/library_repository.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';

class MockLibraryRepository implements LibraryRepository, DocumentRepository {
  @override
  Future<LibraryPageData> getLibraryPage() async {
    return LibraryPageData(
      subjects: [],
      recentDocuments: [],
      savedDocuments: [],
    );
  }

  @override
  Future<LibrarySubjectPageData> getLibrarySubjectPage(String subjectId) async {
    return LibrarySubjectPageData(
      subjectId: subjectId,
      schoolName: 'Trường Đại học Bách Khoa',
      subjectName: 'Môn học $subjectId',
      userCount: 5,
      uploadedDocuments: [],
      topLikedDocuments: [],
      storedDocuments: [],
    );
  }

  @override
  Future<String?> like(String documentId) async {
    return 'liked';
  }

  @override
  Future<String?> bookmark(String documentId) async {
    return 'bookmarked';
  }

  @override
  Future<String?> download(String documentId) async {
    return 'downloaded';
  }
}
