import 'package:studydocs/screens/home/domain/entity/home_documents_page.dart';
import 'package:studydocs/screens/home/domain/repository/home_repository.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';

class MockHomeRepository implements HomeRepository, DocumentRepository {
  @override
  Future<HomeDocumentsPage> getHomeDocuments({
    required int page,
    required int pageSize,
  }) async {
    return HomeDocumentsPage(
      items: [],
      page: page,
      pageSize: pageSize,
      total: 0,
      hasMore: false,
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
