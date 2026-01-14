import 'dart:io' as java_io;
import '../../../docs/domain/entity/document_entity.dart';
import '../../../../data/datasource/docs_management_remote_datasource.dart';
import '../../domain/repository/docs_management_repository.dart';

class DocsManagementRepositoryImpl implements DocsManagementRepository {
  final DocsManagementRemoteDataSource dataSource;

  DocsManagementRepositoryImpl({required this.dataSource});

  @override
  Future<List<DocumentEntity>> getMyDocuments() => dataSource.getMyDocuments();

  @override
  Future<void> deleteDocument(String id) => dataSource.deleteDocument(id);

  @override
  Future<void> updateDocument(String id, DocumentEntity updatedDoc) =>
      dataSource.updateDocument(id, updatedDoc);

  @override
  Future<void> uploadDocument(dynamic file, DocumentEntity metadata) =>
      dataSource.uploadDocument(file, metadata);
}
