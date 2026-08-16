import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';

abstract interface class ReviewRepository {
  Future<void> likeDocument(String documentId);

  Future<void> dislikeDocument(String documentId);
}

class ReviewRepositoryImpl implements ReviewRepository {
  final DocumentRemoteDataSource _dataSource;

  ReviewRepositoryImpl({DocumentRemoteDataSource? dataSource}) : _dataSource = dataSource ?? DocumentRemoteDataSourceImpl();

  @override
  Future<void> likeDocument(String documentId) async {
    await _dataSource.interactWithDocument(documentId, 'LIKE');
  }

  @override
  Future<void> dislikeDocument(String documentId) async {
    await _dataSource.interactWithDocument(documentId, 'DISLIKE');
  }
}
