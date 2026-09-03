import 'package:studydocs/data/datasource/document_remote_datasource.dart';

import 'package:studydocs/screens/document_detail/domain/repository/document_detail_repository.dart';
import 'package:studydocs/screens/document_detail/domain/entity/document_detail_data.dart';
import 'package:studydocs/core/utils/image_utils.dart';

class DocumentDetailRepositoryImpl implements DocumentDetailRepository {
  final DocumentRemoteDataSource _dataSource;

  DocumentDetailRepositoryImpl(this._dataSource);

  @override
  Future<DocumentDetailData> getDocumentDetail(String documentId) async {
    final response = await _dataSource.getDocumentById(documentId);
    
    // The response is already the 'data' field from the API due to DioClient wrapper
    final data = response as Map<String, dynamic>;

    return DocumentDetailData(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
      fileSize: data['fileSize'] ?? 0,
      fileType: data['fileType'] ?? '',
      thumbnail: ImageUtils.fixPdfThumbnail(data['thumbnail']),
      categoryName: data['category'] ?? '',
      schoolName: data['school'] ?? data['universityName'] ?? '',
      pageCount: data['pageCount'] ?? 0,
      year: data['year']?.toString() ?? '',
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      downloadCount: data['downloadCount'] ?? 0,
      viewCount: data['viewCount'] ?? 0,
      isLiked: data['isLiked'] ?? false,
      isBookmarked: data['isBookmarked'] ?? false,
      isPublic: data['isPublic'] ?? true,
      createdAt: data['createdAt'] != null 
          ? DateTime.tryParse(data['createdAt']) ?? DateTime.now() 
          : DateTime.now(),
      // Mapped from uploader details
      authorId: data['uploaderId'] ?? '',
      authorName: data['uploaderName'] ?? 'Unknown User',
      authorAvatar: 'https://i.pravatar.cc/150?u=${data['uploaderId'] ?? 'default'}', // mock avatar
      authorSchoolName: data['universityName'] ?? data['school'] ?? 'Unknown School',
      // Mock remaining missing fields
      dislikeCount: 0,
      isDisliked: false,
    );
  }
}
