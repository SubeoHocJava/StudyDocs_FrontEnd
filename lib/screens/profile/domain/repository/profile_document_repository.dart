import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

class ProfileDocumentRepository {
  final DocumentRemoteDataSource documentDataSource;

  ProfileDocumentRepository({DocumentRemoteDataSource? dataSource})
      : documentDataSource = dataSource ?? DocumentRemoteDataSourceImpl();

  Future<List<DocumentSummaryModel>> getUserDocuments(String userId) async {
    final response = await documentDataSource.getUserDocuments(userId);
    final List<DocumentSummaryModel> items = (response as List)
        .map((e) => DocumentSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return items;
  }
}
