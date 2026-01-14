import 'package:studydocs/data/model/document_model.dart';
import 'package:studydocs/features/docs/domain/entity/document_entity.dart';

abstract class DocumentRemoteDataSource {
  // Lấy danh sách (Dùng cho Home/Search)
  Future<List<DocumentModel>> getDocuments();
  Future<List<DocumentModel>> getPopularDocuments();
  Future<List<DocumentModel>> getRecentDocuments();
  Future<List<DocumentModel>> searchDocuments(String query);

  // Chi tiết & Tương tác (Dùng cho Docs detail)
  Future<DocumentEntity> getDocumentDetails({required String documentId});
  Future<void> toggleSave({required String documentId});
  Future<void> downloadDocument({required String documentId});
  Future<void> toggleLike({required String documentId, required bool isLike});
  Future<void> postComment({required String documentId, required String text});
  
  // Review logic
  Future<void> reactToReview({
    required String documentId,
    required String reviewId, 
    required bool isLike,
  });
}
