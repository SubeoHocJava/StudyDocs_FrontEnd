import 'package:studydocs/screens/home/domain/entity/home_documents_page.dart';
import 'package:studydocs/screens/home/domain/repository/home_repository.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';
import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

class HomeRepositoryImpl implements HomeRepository, DocumentRepository {
  final DocumentRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<HomeDocumentsPage> getHomeDocuments({
    required int page,
    required int pageSize,
  }) async {
    final response = await _remoteDataSource.getDocuments(
      page: page,
      pageSize: pageSize,
    );
    
    final List<DocumentSummaryModel> items = (response as List)
        .map((e) => DocumentSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();

    bool hasMore = items.length == pageSize;

    return HomeDocumentsPage(
      items: items,
      page: page,
      pageSize: pageSize,
      total: items.length,
      hasMore: hasMore,
    );
  }

  @override
  Future<String?> like(String documentId) async {
    try {
      await _remoteDataSource.interactWithDocument(documentId, 'LIKE');
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<String?> bookmark(String documentId) async {
    try {
      await _remoteDataSource.bookmarkDocument(documentId);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<String?> download(String documentId) async {
    try {
      await _remoteDataSource.downloadDocument(documentId);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
