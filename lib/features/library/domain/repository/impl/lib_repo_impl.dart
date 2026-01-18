import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/data/datasource/user_remote_datasource.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../data/datasource/asset_remote_datasource.dart';
import '../../../../../data/datasource/docs_remote_datasource.dart';
import '../../../../../data/datasource/impl/asset_remote_datasource_impl.dart';
import '../../../../../data/datasource/impl/document_remote_datasource_impl.dart';
import '../../../../../data/datasource/impl/user_remote_datasource_impl.dart';
import '../../model/document_library.dart';
import '../library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  late final DocumentRemoteDataSource docRemoteDataSource;
  late final UserRemoteDataSource userRemoteDataSource;
  late final AssetRemoteDataSource assetRemoteDataSource;
  LibraryRepositoryImpl() {
    final dioClient = DioClient();
    assetRemoteDataSource = AssetRemoteDataSourceImpl(dioClient: dioClient);
    userRemoteDataSource=UserDataSourceImpl(dioClient: dioClient, assetRemoteDataSource: assetRemoteDataSource);
    docRemoteDataSource = DocumentRemoteDataSourceImpl(dioClient: dioClient);
  }

  @override
  Future<List<DocumentLibraryUI>> loadDocuments(String keyword) async {
    final documents = await docRemoteDataSource.getDocuments();

    return documents
        .map(
          (doc) => DocumentLibraryUI(
            id: doc.id ?? '',
            fileId: doc.fileId,
            title: doc.title,
            category: doc.course,
            institution: doc.school,
            pages: doc.pages,
            createdAt: doc.year,
            likesCount: doc.likes,
            commentsCount: doc.comments.length,
            thumbnailUrl: doc.previewUrls.isNotEmpty ? doc.previewUrls.first : null,
            isLiked: doc.currentUserReaction == 'like',
            isSaved: doc.isSaved,
          ),
        )
        .toList();
  }

  @override
  Future<List<DocumentLibraryUI>> searchDocuments(String keyword) async {
    final documents = await docRemoteDataSource.searchDocuments(keyword);

    return documents
        .map(
          (doc) => DocumentLibraryUI(
            id: doc.id ?? '',
            fileId: doc.fileId,
            title: doc.title,
            category: doc.course,
            institution: doc.school,
            pages: doc.pages,
            createdAt: doc.year,
            likesCount: doc.likes,
            commentsCount: doc.comments.length,
            thumbnailUrl: doc.previewUrls.isNotEmpty ? doc.previewUrls.first : null,
            isLiked: doc.currentUserReaction == 'like',
            isSaved: doc.isSaved,
          ),
        )
        .toList();
  }

  @override
  Future<void> downloadDocument(String documentId) async {
    docRemoteDataSource.downloadDocument(documentId: documentId);
  }

  @override
  Future<void> saveDocument(String documentId) async {
    userRemoteDataSource.saveDocument(documentId);
  }

  @override
  Future<void> likeDocument(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    docRemoteDataSource.toggleLike(documentId: documentId, isLike: true);
  }

  @override
  Future<List<DocumentLibraryUI>> getSavedDocuments() async {
    // 1. Get saved document IDs from user service
    final response = await userRemoteDataSource.getSavedDocuments();
    
    if (!response.isSuccess || response.data == null) {
      return [];
    }
    
    // 2. Extract IDs from response
    final List<String> documentIds = [];
    if (response.data is List) {
      documentIds.addAll((response.data as List).map((id) => id.toString()));
    }
    
    if (documentIds.isEmpty) {
      return [];
    }
    
    // 3. Fetch document details for each ID
    final documents = await docRemoteDataSource.getDocumentsByIds(documentIds);
    
    // 4. Map to DocumentLibraryUI
    return documents
        .map(
          (doc) => DocumentLibraryUI(
            id: doc.id ?? '',
            fileId: doc.fileId,
            title: doc.title,
            category: doc.course,
            institution: doc.school,
            pages: doc.pages,
            createdAt: doc.year,
            likesCount: doc.likes,
            commentsCount: doc.comments.length,
            thumbnailUrl: doc.previewUrls.isNotEmpty ? doc.previewUrls.first : null,
            isLiked: doc.currentUserReaction == 'like',
            isSaved: doc.isSaved,
          ),
        )
        .toList();
  }
}
