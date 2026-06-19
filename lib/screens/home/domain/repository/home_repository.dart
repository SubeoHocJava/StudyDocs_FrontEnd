import '../entity/home_documents_page.dart';

abstract interface class HomeRepository {
  Future<HomeDocumentsPage> getHomeDocuments({
    required int page,
    required int pageSize,
  });
}
