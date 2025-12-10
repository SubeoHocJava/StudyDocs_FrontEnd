import '../../../../../data/datasource/docs_remote_datasource.dart';
import '../../../../docs/domain/entity/document_entity.dart';
import '../docs_repository.dart';


class DocsRepositoryImpl implements DocsRepository {
  final DocsRemoteDataSource dataSource;

  DocsRepositoryImpl({required this.dataSource});

  @override
  Future<DocumentEntity> getDocumentDetails() => dataSource.getDocumentDetails();

  @override
  Future<void> toggleSave() async {
    await dataSource.toggleSave();
  }

  @override
  Future<void> downloadDocument() async {
    await dataSource.downloadDocument();
  }

  @override
  Future<void> toggleLike({required bool isLike}) async {
    await dataSource.toggleLike(isLike: isLike);
  }

  @override
  Future<void> postComment(String text) async {
    await dataSource.postComment(text);
  }
}