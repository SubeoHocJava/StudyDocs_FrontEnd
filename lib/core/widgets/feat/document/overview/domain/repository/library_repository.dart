import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';

abstract interface class LibraryRepository {
  Future<void> save(String id);

  Future<void> unsave(String id);
}

class LibraryRepositoryImpl implements LibraryRepository {
  final DocumentRemoteDataSource _dataSource;

  LibraryRepositoryImpl({DocumentRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? DocumentRemoteDataSourceImpl();

  @override
  Future<void> save(String id) async {
    await _dataSource.bookmarkDocument(id);
  }

  @override
  Future<void> unsave(String id) async {
    await _dataSource.bookmarkDocument(id);
  }
}
