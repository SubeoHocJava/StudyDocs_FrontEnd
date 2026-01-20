import 'dart:io' as java_io;
import '../../../docs/domain/entity/document_entity.dart';
import '../../../docs/data/model/document_model.dart';
import '../../../../data/datasource/docs_management_remote_datasource.dart';
import '../../../../data/datasource/academic_remote_datasource.dart';
import '../../domain/repository/docs_management_repository.dart';

class DocsManagementRepositoryImpl implements DocsManagementRepository {
  final DocsManagementRemoteDataSource dataSource;
  final AcademicRemoteDataSource academicDataSource;

  DocsManagementRepositoryImpl({
    required this.dataSource,
    required this.academicDataSource,
  });

  @override
  Future<List<DocumentEntity>> getMyDocuments() async {
    // Fetch raw documents from datasource
    final docs = await dataSource.getMyDocuments();
    
    // Enrich with school/subject names
    return _enrichDocuments(docs);
  }

  @override
  Future<List<DocumentEntity>> getAllDocuments() async {
    // Fetch raw documents from datasource
    final docs = await dataSource.getAllDocuments();
    
    // Enrich with school/subject names
    return _enrichDocuments(docs);
  }

  /// Enrich documents with school and subject names from IDs
  Future<List<DocumentEntity>> _enrichDocuments(List<DocumentEntity> docs) async {
    if (docs.isEmpty) return docs;

    // Extract unique university and subject IDs
    final universityIds = docs
        .where((doc) => doc.universityId != null && doc.universityId!.isNotEmpty)
        .map((doc) => doc.universityId!)
        .toSet()
        .toList();

    final subjectIds = docs
        .where((doc) => doc.subjectId != null && doc.subjectId!.isNotEmpty)
        .map((doc) => doc.subjectId!)
        .toSet()
        .toList();

    // Batch fetch universities and subjects in parallel
    final results = await Future.wait([
      _fetchUniversitiesByIds(universityIds),
      _fetchSubjectsByIds(subjectIds),
    ]);

    final universityMap = results[0];
    final subjectMap = results[1];

    // Map documents with enriched names
    return docs.map((doc) {
      final schoolName = doc.universityId != null
          ? universityMap[doc.universityId!] ?? doc.school
          : doc.school;

      final courseName = doc.subjectId != null
          ? subjectMap[doc.subjectId!] ?? doc.course
          : doc.course;

      return DocumentEntity(
        id: doc.id,
        title: doc.title,
        description: doc.description,
        course: courseName,
        school: schoolName,
        year: doc.year,
        uploader: doc.uploader,
        uploaderId: doc.uploaderId,
        likes: doc.likes,
        dislikes: doc.dislikes,
        comments: doc.comments,
        isSaved: doc.isSaved,
        pages: doc.pages,
        fileSize: doc.fileSize,
        downloadUrl: doc.downloadUrl,
        fileId: doc.fileId,
        currentUserReaction: doc.currentUserReaction,
        previewUrls: doc.previewUrls,
        subjectId: doc.subjectId,
        universityId: doc.universityId,
        commentsCount: doc.commentsCount,
        createdAt: doc.createdAt,
      );
    }).toList();
  }

  /// Fetch universities by IDs in parallel
  Future<Map<String, String>> _fetchUniversitiesByIds(List<String> ids) async {
    if (ids.isEmpty) return {};

    final Map<String, String> result = {};

    // Parallel fetch all universities
    final futures = ids.map((id) async {
      try {
        final university = await academicDataSource.getUniversityById(id);
        return MapEntry(id, university.name);
      } catch (e) {
        // If fetch fails, return placeholder
        return MapEntry(id, 'Unknown University');
      }
    });

    final entries = await Future.wait(futures);
    result.addAll(Map.fromEntries(entries));

    return result;
  }

  /// Fetch subjects by IDs in parallel
  Future<Map<String, String>> _fetchSubjectsByIds(List<String> ids) async {
    if (ids.isEmpty) return {};

    final Map<String, String> result = {};

    final futures = ids.map((id) async {
      try {
        final subject = await academicDataSource.getSubjectById(id);
        return MapEntry(id, subject.name);
      } catch (e) {
        // If fetch fails, return placeholder
        return MapEntry(id, 'Unknown Subject');
      }
    });

    final entries = await Future.wait(futures);
    result.addAll(Map.fromEntries(entries));

    return result;
  }

  @override
  Future<void> deleteDocument(String id) => dataSource.deleteDocument(id);

  @override
  Future<void> deleteAdminDocument(String id) => dataSource.deleteAdminDocument(id);

  @override
  Future<void> updateDocument(String id, DocumentEntity updatedDoc) =>
      dataSource.updateDocument(id, updatedDoc);

  @override
  Future<void> updateAdminDocument(String id, DocumentEntity updatedDoc) =>
      dataSource.updateAdminDocument(id, updatedDoc);

  @override
  Future<void> uploadDocument(dynamic file, DocumentEntity metadata) =>
      dataSource.uploadDocument(file, metadata);
}
