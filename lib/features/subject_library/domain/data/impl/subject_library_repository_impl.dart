import 'package:flutter/foundation.dart';
import 'package:studydocs/data/datasource/academic_remote_datasource.dart';
import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/data/model/document_model.dart';
import '../../ui_model/CommentEntity.dart';
import '../../ui_model/doc_subject_lib_ui.dart';
import '../subject_library_repository.dart';

class SubjectLibraryRepositoryImpl implements SubjectLibraryRepository {
  final DocumentRemoteDataSource documentDataSource;
  final AcademicRemoteDataSource academicDataSource;

  SubjectLibraryRepositoryImpl({
    required this.documentDataSource,
    required this.academicDataSource,
  });

  @override
  Future<List<DocumentSubjectLibUI>> searchDocuments(String query) async {
    try {
      final models = await documentDataSource.searchDocuments(query);
      return models.map<DocumentSubjectLibUI>((item) => _mapModelToUI(item)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<DocumentSubjectLibUI>> getDocumentsByAcademicId({String? universityId, String? subjectId}) async {
    try {
      // 1. Get List of IDs
      final ids = await academicDataSource.getDocumentIds(universityId: universityId, subjectId: subjectId);
      
      if (ids.isEmpty) return [];

      // 2. Fetch details parallel - Thêm xử lý lỗi từng item để tránh fail cả list
      final futures = ids.map((id) async {
        try {
          return await documentDataSource.getPublicDocumentById(id);
        } catch (e) {
          if (kDebugMode) {
            print('SubjectLibraryRepositoryImpl: Failed to fetch doc detail for ID: $id - $e');
          }
          return null;
        }
      });
      
      final results = await Future.wait(futures);
      final validModels = results.whereType<DocumentModel>().toList();

      // 3. Map to UI Model
      return validModels.map((item) => _mapModelToUI(item)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('SubjectLibraryRepositoryImpl.getDocumentsByAcademicId FATAL ERROR: $e');
      }
      return [];
    }
  }

  DocumentSubjectLibUI _mapModelToUI(item) {
     return DocumentSubjectLibUI(
        id: item.id,
        title: item.title,
        category: item.category ?? 'General',
        institution: item.institution ?? 'Unknown School',
        pages: item.pageCount ?? 0,
        createdAt: item.createdAt ?? '',
        likesCount: item.likesCount ?? 0,
        commentsCount: item.commentsCount ?? 0,
        thumbnailUrl: item.thumbnailUrl,
        isLiked: false,
        isSaved: false,
      );
  }

  @override
  Future<void> likeDocument(String documentId) async {
    await documentDataSource.toggleLike(documentId: documentId, isLike: true);
  }

  @override
  Future<List<CommentEntity>> getComments(String documentId) async {
    try {
      final entity = await documentDataSource.getDocumentDetails(documentId: documentId);
      return entity.comments.map((e) => CommentEntity(
        id: '',
        username: e.author,
        avatarUrl: null,
        content: e.text,
        createdAt: '',
      )).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String> downloadDocument(String documentId) async {
    await documentDataSource.downloadDocument(documentId: documentId);
    return ""; // Mock path
  }

  @override
  Future<void> bookmarkDocument(String documentId) async {
    await documentDataSource.toggleSave(documentId: documentId);
  }
}

