import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import '../../../../docs/domain/entity/document_entity.dart';
import '../docs_repository.dart';

class DocsRepositoryImpl implements DocsRepository {
  final DocumentRemoteDataSource dataSource;

  DocsRepositoryImpl({required this.dataSource});

  @override
  Future<DocumentEntity> getDocumentDetails({required String documentId}) =>
      dataSource.getDocumentDetails(documentId: documentId);

  @override
  Future<void> toggleSave({required String documentId}) async {
    await dataSource.toggleSave(documentId: documentId);
  }

  @override
  Future<void> downloadDocument({required String documentId}) async {
    await dataSource.downloadDocument(documentId: documentId);
  }

  @override
  Future<void> toggleLike({required String documentId, required bool isLike}) async {
    await dataSource.toggleLike(documentId: documentId, isLike: isLike);
  }

  @override
  Future<void> postComment({required String documentId, required String text}) async {
    await dataSource.postComment(documentId: documentId, text: text);
  }

  @override
  Future<void> reactToReview({
    required String documentId,
    required String reviewId,
    required bool isLike,
  }) async {
    await dataSource.reactToReview(
      documentId: documentId,
      reviewId: reviewId,
      isLike: isLike,
    );
  }
}