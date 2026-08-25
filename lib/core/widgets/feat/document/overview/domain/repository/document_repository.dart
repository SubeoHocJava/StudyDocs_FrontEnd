import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';

abstract interface class DocumentRepository {
  Future<String> download(String id);
}

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentRemoteDataSource _dataSource;

  DocumentRepositoryImpl({DocumentRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? DocumentRemoteDataSourceImpl();

  @override
  Future<String> download(String id) async {
    try {
      await _dataSource.downloadDocument(id);
      return "success";
    } catch (e) {
      return "";
    }
  }
}

