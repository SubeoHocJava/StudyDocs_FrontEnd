import 'dart:async';

import '../../../../core/network/dio_client.dart';
import '../../core/constants/review_api_constants.dart';
import '../../core/constants/document_api_constants.dart';
import '../../features/docs/domain/entity/document_entity.dart';
import '../../features/subject_library/domain/ui_model/CommentEntity.dart' hide CommentEntity;

abstract class DocsRemoteDataSource {
  Future<DocumentEntity> getDocumentDetails();
  Future<void> toggleSave();
  Future<void> downloadDocument();
  Future<void> toggleLike({required bool isLike});
  Future<void> postComment(String text);
  Future<void> reactToReview({required String reviewId, required bool isLike});
}


