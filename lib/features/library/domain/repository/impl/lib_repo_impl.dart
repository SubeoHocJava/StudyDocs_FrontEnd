import 'package:studydocs/data/datasource/academic_remote_datasource.dart';
import 'package:studydocs/data/datasource/asset_remote_datasource.dart';
import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/datasource/docs_remote_datasource.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../data/datasource/impl/academic_remote_datasource_impl.dart';
import '../../../../../data/datasource/impl/asset_remote_datasource_impl.dart';
import '../../../../../data/datasource/impl/document_remote_datasource_impl.dart';
import '../../../../../data/datasource/impl/user_remote_datasource_impl.dart';

import '../../model/document_library.dart';
import '../library_repository.dart';
import '../../../../docs/data/model/document_model.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  late final DocumentRemoteDataSource documentRemoteDataSource;
  late final UserRemoteDataSource userRemoteDataSource;
  late final AssetRemoteDataSource assetRemoteDataSource;
  late final AcademicRemoteDataSource academicRemoteDataSource;

  LibraryRepositoryImpl() {
    final dioClient = DioClient();

    assetRemoteDataSource =
        AssetRemoteDataSourceImpl(dioClient: dioClient);

    academicRemoteDataSource =
        AcademicRemoteDataSourceImpl(dioClient: dioClient);

    userRemoteDataSource = UserDataSourceImpl(
      dioClient: dioClient,
      assetRemoteDataSource: assetRemoteDataSource,
    );

    documentRemoteDataSource =
        DocumentRemoteDataSourceImpl(dioClient: dioClient);
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // LOAD DOCUMENTS (Academic Enriched)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  Future<List<DocumentLibraryUI>> loadDocuments(String keyword) async {
    // 1. Fetch documents
    var documents = await documentRemoteDataSource.getDocuments();

    // 2. Extract unique university & subject IDs
    final universityIds = documents
        .where((doc) => doc.universityId != null && doc.universityId!.isNotEmpty)
        .map((doc) => doc.universityId!)
        .toSet()
        .toList();

    final subjectIds = documents
        .where((doc) => doc.subjectId != null && doc.subjectId!.isNotEmpty)
        .map((doc) => doc.subjectId!)
        .toSet()
        .toList();

    // 3. Fetch academic info in parallel
    final results = await Future.wait([
      _fetchUniversitiesByIds(universityIds),
      _fetchSubjectsByIds(subjectIds),
    ]);

    final universityMap = results[0];
    final subjectMap = results[1];

    // 4. Map to UI model
    return documents.map((doc) {
      final institutionName =
      doc.universityId != null
          ? universityMap[doc.universityId!] ?? doc.school
          : doc.school;

      final categoryName =
      doc.subjectId != null
          ? subjectMap[doc.subjectId!] ?? doc.course
          : doc.course;

      return DocumentLibraryUI(
        id: doc.id ?? '',
        fileId: doc.fileId,
        title: doc.title,
        category: categoryName,
        institution: institutionName,
        pages: doc.pages,
        createdAt: doc.year,
        likesCount: doc.likes,
        commentsCount: doc.comments.length,
        thumbnailUrl:
        doc.previewUrls.isNotEmpty ? doc.previewUrls.first : null,
        isLiked: doc.currentUserReaction == 'LIKE',
        isSaved: doc.isSaved,
      );
    }).toList();
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // SEARCH DOCUMENTS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  Future<List<DocumentLibraryUI>> searchDocuments(String keyword) async {
    var documents =
    await documentRemoteDataSource.searchDocuments(keyword);

    final universityIds = documents
        .where((doc) => doc.universityId != null && doc.universityId!.isNotEmpty)
        .map((doc) => doc.universityId!)
        .toSet()
        .toList();

    final subjectIds = documents
        .where((doc) => doc.subjectId != null && doc.subjectId!.isNotEmpty)
        .map((doc) => doc.subjectId!)
        .toSet()
        .toList();

    final results = await Future.wait([
      _fetchUniversitiesByIds(universityIds),
      _fetchSubjectsByIds(subjectIds),
    ]);

    final universityMap = results[0];
    final subjectMap = results[1];

    return documents.map((doc) {
      final institutionName =
      doc.universityId != null
          ? universityMap[doc.universityId!] ?? doc.school
          : doc.school;

      final categoryName =
      doc.subjectId != null
          ? subjectMap[doc.subjectId!] ?? doc.course
          : doc.course;

      return DocumentLibraryUI(
        id: doc.id ?? '',
        fileId: doc.fileId,
        title: doc.title,
        category: categoryName,
        institution: institutionName,
        pages: doc.pages,
        createdAt: doc.year,
        likesCount: doc.likes,
        commentsCount: doc.comments.length,
        thumbnailUrl:
        doc.previewUrls.isNotEmpty ? doc.previewUrls.first : null,
        isLiked: doc.currentUserReaction == 'LIKE',
        isSaved: doc.isSaved,
      );
    }).toList();
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // USER ACTIONS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  Future<void> downloadDocument(String documentId) async {
    await documentRemoteDataSource.downloadDocument(
      documentId: documentId,
    );
  }

  @override
  Future<void> saveDocument(String documentId) async {
    await userRemoteDataSource.saveDocument(documentId);
  }

  @override
  Future<void> likeDocument(String documentId) async {
    await documentRemoteDataSource.toggleLike(
      documentId: documentId,
      isLike: true,
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // SAVED DOCUMENTS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @override
  Future<List<DocumentLibraryUI>> getSavedDocuments() async {
    final response = await userRemoteDataSource.getSavedDocuments();

    if (!response.isSuccess || response.data == null) {
      return [];
    }

    final documentIds =
    (response.data as List).map((e) => e.toString()).toList();

    if (documentIds.isEmpty) {
      return [];
    }

    final documents =
    await documentRemoteDataSource.getDocumentsByIds(documentIds);

    final universityIds = documents
        .where((doc) => doc.universityId != null && doc.universityId!.isNotEmpty)
        .map((doc) => doc.universityId!)
        .toSet()
        .toList();

    final subjectIds = documents
        .where((doc) => doc.subjectId != null && doc.subjectId!.isNotEmpty)
        .map((doc) => doc.subjectId!)
        .toSet()
        .toList();

    final results = await Future.wait([
      _fetchUniversitiesByIds(universityIds),
      _fetchSubjectsByIds(subjectIds),
    ]);

    final universityMap = results[0];
    final subjectMap = results[1];

    return documents.map((doc) {
      final institutionName =
      doc.universityId != null
          ? universityMap[doc.universityId!] ?? doc.school
          : doc.school;

      final categoryName =
      doc.subjectId != null
          ? subjectMap[doc.subjectId!] ?? doc.course
          : doc.course;

      return DocumentLibraryUI(
        id: doc.id ?? '',
        fileId: doc.fileId,
        title: doc.title,
        category: categoryName,
        institution: institutionName,
        pages: doc.pages,
        createdAt: doc.year,
        likesCount: doc.likes,
        commentsCount: doc.comments.length,
        thumbnailUrl:
        doc.previewUrls.isNotEmpty ? doc.previewUrls.first : null,
        isLiked: doc.currentUserReaction == 'LIKE',
        isSaved: true,
      );
    }).toList();
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // HELPER METHODS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Future<Map<String, String>> _fetchUniversitiesByIds(
      List<String> ids,
      ) async {
    if (ids.isEmpty) return {};

    final futures = ids.map((id) async {
      try {
        final uni = await academicRemoteDataSource.getUniversityById(id);
        return MapEntry(id, uni.name);
      } catch (_) {
        return MapEntry(id, 'Unknown University');
      }
    });

    return Map.fromEntries(await Future.wait(futures));
  }

  Future<Map<String, String>> _fetchSubjectsByIds(
      List<String> ids,
      ) async {
    if (ids.isEmpty) return {};

    final futures = ids.map((id) async {
      try {
        final subject = await academicRemoteDataSource.getSubjectById(id);
        return MapEntry(id, subject.name);
      } catch (_) {
        return MapEntry(id, 'Unknown Subject');
      }
    });

    return Map.fromEntries(await Future.wait(futures));
  }
}
