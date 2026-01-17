import 'package:studydocs/data/datasource/document_remote_datasource.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../data/datasource/impl/document_remote_datasource_impl.dart';
import '../../model/document_library.dart';
import '../library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  late final DocumentRemoteDataSource docRemoteDataSource;

  LibraryRepositoryImpl() {
    final dioClient = DioClient();
    docRemoteDataSource = DocumentRemoteDataSourceImpl(dioClient: dioClient);
  }

  @override
  Future<List<DocumentLibraryUI>> loadDocuments(String keyword) async {
    final documents = await docRemoteDataSource.getMyDocuments();

    return documents
        .map(
          (doc) => DocumentLibraryUI(
            id: doc.id,
            fileId: doc.fileId,
            title: doc.title,
            category: doc.category ?? doc.subjectId ?? 'Không xác định',
            institution:
                doc.institution ?? doc.universityId ?? 'Không xác định',
            pages: doc.pageCount ?? 0,
            createdAt: doc.createdAt ?? '',
            likesCount: doc.likesCount ?? 0,
            commentsCount: doc.commentsCount ?? 0,
            thumbnailUrl: doc.thumbnailUrl,
            isLiked: false,
            isSaved: false,
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
            id: doc.id,
            fileId: doc.fileId,
            title: doc.title,
            category: doc.category ?? doc.subjectId ?? 'Không xác định',
            institution:
                doc.institution ?? doc.universityId ?? 'Không xác định',
            pages: doc.pageCount ?? 0,
            createdAt: doc.createdAt ?? '',
            likesCount: doc.likesCount ?? 0,
            commentsCount: doc.commentsCount ?? 0,
            thumbnailUrl: doc.thumbnailUrl,
            isLiked: false,
            isSaved: false,
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
    docRemoteDataSource.toggleSave(documentId: documentId);
  }

  @override
  Future<void> likeDocument(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    docRemoteDataSource.toggleLike(documentId: documentId, isLike: true);
  }
}
