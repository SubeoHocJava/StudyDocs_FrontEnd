import 'dart:async';

import '../../features/docs/domain/entity/document_entity.dart';

abstract class DocsRemoteDataSource {
  Future<DocumentEntity> getDocumentDetails();
  Future<void> toggleSave();
  Future<void> downloadDocument();
  Future<void> toggleLike({required bool isLike});
  Future<void> postComment(String text);
  Future<void> reactToReview({required String reviewId, required bool isLike});
}


