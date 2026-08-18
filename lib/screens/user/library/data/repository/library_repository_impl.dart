import 'package:studydocs/screens/user/library/domain/entity/library_page_data.dart';
import 'package:studydocs/screens/user/library/domain/entity/library_subject_page_data.dart';
import 'package:studydocs/screens/user/library/domain/repository/library_repository.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';
import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';
import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';

class LibraryRepositoryImpl implements LibraryRepository, DocumentRepository {
  final DocumentRemoteDataSource _remoteDataSource;

  LibraryRepositoryImpl(this._remoteDataSource);

  @override
  Future<LibraryPageData> getLibraryPage() async {
    final historyResponse = await _remoteDataSource.getMyHistoryDocuments();
    final myDocsResponse = await _remoteDataSource.getMyDocuments();

    final List<DocumentCompactModel> recentDocs = (historyResponse as List)
        .map((e) => DocumentCompactModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final List<DocumentSummaryModel> savedDocs = (myDocsResponse as List)
        .map((e) => DocumentSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return LibraryPageData(
      subjects: const [],
      recentDocuments: recentDocs,
      savedDocuments: savedDocs,
    );
  }

  @override
  Future<LibrarySubjectPageData> getLibrarySubjectPage(String subjectId) async {
    return LibrarySubjectPageData(
      subjectId: subjectId,
      schoolName: 'Trường Đại học Bách Khoa',
      subjectName: 'Môn học $subjectId',
      userCount: 5,
      uploadedDocuments: const [],
      topLikedDocuments: const [],
      storedDocuments: const [],
    );
  }

  @override
  Future<String?> like(String documentId) async {
    await _remoteDataSource.interactWithDocument(documentId, 'LIKE');
    return 'liked';
  }

  @override
  Future<String?> bookmark(String documentId) async {
    await _remoteDataSource.bookmarkDocument(documentId);
    return 'bookmarked';
  }

  @override
  Future<String?> download(String documentId) async {
    await _remoteDataSource.downloadDocument(documentId);
    return 'downloaded';
  }
}
