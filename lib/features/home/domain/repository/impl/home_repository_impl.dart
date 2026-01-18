import 'package:flutter/foundation.dart';
import 'package:studydocs/data/datasource/academic_remote_datasource.dart';
import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/data/datasource/asset_remote_datasource.dart'; // ✅ Import Asset
import 'package:studydocs/data/datasource/docs_remote_datasource.dart'; // ✅ Import Docs
import 'package:studydocs/features/home/domain/entity/document_entity.dart';
import 'package:studydocs/features/home/domain/repository/home_repository.dart';

import '../../../../docs/data/model/document_model.dart';



class HomeRepositoryImpl implements HomeRepository {
  final DocumentRemoteDataSource remoteDataSource;
  final AcademicRemoteDataSource academicDataSource;
  final AssetRemoteDataSource assetDataSource;
  final DocsRemoteDataSource docsRemoteDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.academicDataSource,
    required this.assetDataSource,
    required this.docsRemoteDataSource,
  });

  @override
  Future<List<DocumentEntity>> getDocuments() async {
    try {
      var models = await remoteDataSource.getDocuments();

      // Enrich with assets (thumbnails)
      models = await _enrichWithAssets(models);

      return models.map((model) => DocumentEntity.fromModel(model)).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get documents - $e');
    }
  }

  @override
  Future<List<DocumentEntity>> getPopularDocuments() async {
    try {
      // 1. Fetch documents với IDs từ API
      var documents = await remoteDataSource.getPopularDocuments();

      // 1b. Enrich with assets (thumbnails)
      documents = await _enrichWithAssets(documents);

      // 1c. Enrich with stats (likes, reaction)
      documents = await _enrichWithStats(documents);

      if (kDebugMode) {
        print('--- HomeRepository.getPopularDocuments Debug ---');
        for (var doc in documents) {
          print('DocID: ${doc.id} | Title: ${doc.title} | UniID: ${doc.universityId} | SubID: ${doc.subjectId}');
        }
      }

      // 2. Extract unique university IDs và subject IDs
      final universityIds =
          documents
              .where(
                (doc) =>
                    doc.universityId != null && doc.universityId!.isNotEmpty,
              )
              .map((doc) => doc.universityId!)
              .toSet()
              .toList();

      final subjectIds =
          documents
              .where(
                (doc) => doc.subjectId != null && doc.subjectId!.isNotEmpty,
              )
              .map((doc) => doc.subjectId!)
              .toSet()
              .toList();

      // 3. Batch fetch universities và subjects (parallel)
      final results = await Future.wait([
        _fetchUniversitiesByIds(universityIds),
        _fetchSubjectsByIds(subjectIds),
      ]);

      final universityMap = results[0];
      final subjectMap = results[1];

      // 4. Map documents → entities với tên đầy đủ
      return documents.map((doc) {
        final institutionName =
            doc.universityId != null
                ? universityMap[doc.universityId!] ??
                    doc.school // Corrected
                : doc.school; // Corrected

        final categoryName =
            doc.subjectId != null
                ? subjectMap[doc.subjectId!] ??
                    doc.course // Corrected
                : doc.course; // Corrected

        return DocumentEntity(
          id: doc.id ?? '',
          title: doc.title,
          description: doc.description,
          institution: institutionName, 
          category: categoryName, 
          academicYear: doc.year, // Corrected
          viewCount: 0, // Default
          downloadCount: 0, // Default
          likesCount: doc.likes,
          commentsCount: doc.commentsCount ?? doc.comments.length,
          rating: 0.0,
          thumbnailUrl: doc.previewUrls.isNotEmpty ? doc.previewUrls.first : null,
          isLiked: doc.currentUserReaction == 'LIKE',
          pageCount: doc.pages,
        );
      }).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get popular documents - $e');
    }
  }

  @override
  Future<List<DocumentEntity>> getRecentDocuments() async {
    try {
      //  Apply orchestration pattern tương tự Popular Documents
      var documents = await remoteDataSource.getRecentDocuments();

      // Enrich with assets (thumbnails)
      documents = await _enrichWithAssets(documents);

      // Enrich with stats (likes, reaction)
      documents = await _enrichWithStats(documents);

      if (kDebugMode) {
        print('--- HomeRepository.getRecentDocuments Debug ---');
        for (var doc in documents) {
          print('DocID: ${doc.id} | Title: ${doc.title} | UniID: ${doc.universityId} | SubID: ${doc.subjectId}');
        }
      }

      final universityIds =
          documents
              .where(
                (doc) =>
                    doc.universityId != null && doc.universityId!.isNotEmpty,
              )
              .map((doc) => doc.universityId!)
              .toSet()
              .toList();

      final subjectIds =
          documents
              .where(
                (doc) => doc.subjectId != null && doc.subjectId!.isNotEmpty,
              )
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
                ? universityMap[doc.universityId!] ??
                    doc.school 
                : doc.school;

        final categoryName =
            doc.subjectId != null
                ? subjectMap[doc.subjectId!] ??
                    doc.course 
                : doc.course;

        return DocumentEntity(
          id: doc.id ?? '',
          title: doc.title,
          description: doc.description,
          institution: institutionName,
          category: categoryName,
          academicYear: doc.year,
          viewCount: 0,
          downloadCount: 0,
          likesCount: doc.likes,
          commentsCount: doc.commentsCount ?? doc.comments.length,
          rating: 0.0,
          thumbnailUrl: doc.previewUrls.isNotEmpty ? doc.previewUrls.first : null,
          isLiked: doc.currentUserReaction == 'LIKE',
          pageCount: doc.pages,
        );
      }).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get recent documents - $e');
    }
  }

  @override
  Future<List<DocumentEntity>> searchDocuments(String query) async {
    try {
      var models = await remoteDataSource.searchDocuments(query);
      models = await _enrichWithAssets(models);
      models = await _enrichWithStats(models);
      return models.map((model) => DocumentEntity.fromModel(model)).toList();
    } catch (e) {
      throw Exception('Repository: Failed to search documents - $e');
    }
  }

  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  /// 🔧 HELPER METHODS - Assets Enrichment
  /// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  /// Enrich document list with thumbnails from Asset Service if missing
  Future<List<DocumentModel>> _enrichWithAssets(
    List<DocumentModel> docs,
  ) async {
    // Run in parallel for performance
    final futures = docs.map((doc) async {
      // Logic: If thumbnail is missing AND we have a fileId -> fetch asset info
      if (doc.previewUrls.isEmpty &&
          doc.fileId != null &&
          doc.fileId!.isNotEmpty) {
        try {
          final asset = await assetDataSource.getAssetById(doc.fileId!);
          final previewUrls = asset.previewUrls;
          if (previewUrls.isNotEmpty) {
            // Found a preview URL, update the document model
            return doc.copyWith(previewUrls: previewUrls);
          }
        } catch (_) {
          // Keep original doc on error
        }
      }
      return doc;
    });

    return Future.wait(futures);
  }

  /// Enrich document list with interaction stats (likes, user reaction) from Review Service
  Future<List<DocumentModel>> _enrichWithStats(
    List<DocumentModel> docs,
  ) async {
    final futures = docs.map((doc) async {
      // Skip if no ID
      if (doc.id == null) return doc;

      try {
        // Parallel fetch stats, reaction, and comment count
        final results = await Future.wait([
          docsRemoteDataSource.getDocumentStats(doc.id!),
          docsRemoteDataSource.getMyDocumentReaction(doc.id!),
          docsRemoteDataSource.getReviewCount(doc.id!),
        ]);

        final stats = results[0] as Map<String, dynamic>;
        final reaction = results[1] as String?;
        final commentCount = results[2] as int;

        final likes = (stats['likeCount'] as num?)?.toInt() ?? 0;
        final dislikes = (stats['dislikeCount'] as num?)?.toInt() ?? 0;

        return doc.copyWith(
          likes: likes,
          dislikes: dislikes,
          commentsCount: commentCount,
          currentUserReaction: reaction,
        );
      } catch (e) {
        // Fail silently and return original doc
        return doc;
      }
    });

    return Future.wait(futures);
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  HELPER METHODS - Batch fetch names by IDs
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

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
        e.toString();
        // Nếu 1 university fetch fail → không crash toàn bộ
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
        // Nếu 1 subject fetch fail → không crash toàn bộ
        return MapEntry(id, 'Unknown Subject');
      }
    });

    final entries = await Future.wait(futures);
    result.addAll(Map.fromEntries(entries));

    return result;
  }
}
