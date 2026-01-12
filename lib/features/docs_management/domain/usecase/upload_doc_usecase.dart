import 'dart:io';
import '../repository/docs_management_repository.dart';
import '../../../docs/domain/entity/document_entity.dart';

class UploadDocUseCase {
  final DocsManagementRepository repository;

  UploadDocUseCase(this.repository);

  Future<void> call(File file, DocumentEntity metadata) async {
    return repository.uploadDocument(file, metadata);
  }
}
