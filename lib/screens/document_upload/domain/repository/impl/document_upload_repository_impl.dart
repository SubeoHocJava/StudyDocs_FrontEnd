import 'package:dio/dio.dart';
import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';

import '../document_upload_repository.dart';


class DocumentUploadRepositoryImpl implements DocumentUploadRepository {
  final DocumentRemoteDataSource _dataSource;

  DocumentUploadRepositoryImpl({DocumentRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? DocumentRemoteDataSourceImpl();

  @override
  Future<dynamic> uploadDocument(FormData data) async {
    return await _dataSource.uploadDocument(data);
  }
}
