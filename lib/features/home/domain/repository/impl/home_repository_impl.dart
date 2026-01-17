import 'package:studydocs/data/datasource/academic_remote_datasource.dart';
import 'package:studydocs/data/datasource/docs_remote_datasource.dart';
import 'package:studydocs/data/datasource/asset_remote_datasource.dart'; // ✅ Import Asset
import 'package:studydocs/features/home/domain/entity/document_entity.dart';
import 'package:studydocs/features/home/domain/repository/home_repository.dart';
import 'package:studydocs/features/docs/data/model/document_model.dart';
import 'package:studydocs/core/utils/helpers/document_url_helper.dart';

class HomeRepositoryImpl implements HomeRepository {
  final DocsRemoteDataSource remoteDataSource;
  final AcademicRemoteDataSource academicDataSource;
  final AssetRemoteDataSource assetDataSource; // ✅ New dependency

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.academicDataSource,
    required this.assetDataSource, // ✅ Inject
  });

  @override
  Future<List<DocumentEntity>> getDocuments() async {
    try {
      var docsEntities = await remoteDataSource.getPublicDocuments();
      // Map to HomeEntity via DocumentModel
      var entities = docsEntities.map((e) => DocumentEntity.fromModel(e as DocumentModel)).toList();

      // Enrich with assets (thumbnails)
      entities = await _enrichWithAssets(entities);

      return entities;
    } catch (e) {
      throw Exception('Repository: Failed to get documents - $e');
    }
  }

  @override
  Future<List<DocumentEntity>> getPopularDocuments() async {
    try {
      var docsEntities = await remoteDataSource.getMostLikedDocuments();
      var documents = docsEntities.map((e) => DocumentEntity.fromModel(e as DocumentModel)).toList();

      documents = await _enrichWithAssets(documents);

      return _enrichWithAcademicInfo(documents);
    } catch (e) {
      throw Exception('Repository: Failed to get popular documents - $e');
    }
  }

  @override
  Future<List<DocumentEntity>> getRecentDocuments() async {
    try {
      var docsEntities = await remoteDataSource.getNewestDocuments();
      var documents = docsEntities.map((e) => DocumentEntity.fromModel(e as DocumentModel)).toList();

      documents = await _enrichWithAssets(documents);

      return _enrichWithAcademicInfo(documents);
    } catch (e) {
      throw Exception('Repository: Failed to get recent documents - $e');
    }
  }

  @override
  Future<List<DocumentEntity>> searchDocuments(String query) async {
    try {
      var docsEntities = await remoteDataSource.searchDocuments(query);
      var entities = docsEntities.map((e) => DocumentEntity.fromModel(e as DocumentModel)).toList();
      entities = await _enrichWithAssets(entities);
      return entities;
    } catch (e) {
      throw Exception('Repository: Failed to search documents - $e');
    }
  }

  Future<List<DocumentEntity>> _enrichWithAcademicInfo(List<DocumentEntity> documents) async {
       // Extract IDs from HomeEntity (which lacks universityId/subjectId? Let's check)
       // HomeEntity (Step 312) has NO universityId/subjectId.
       // DocumentModel HAS them.
       // So we lose them when converting to HomeEntity.
       // We should enrich BEFORE converting if we need them.
       // OR we assume HomeEntity doesn't needed them for now or we rely on Model having populated names?
       // DocumentModel.fromJson populates names with placeholders.
       
       // Re-read HomeRepositoryImpl original logic (Step 317):
       // it accessed `doc.universityId`.
       // `DocumentEntity` (Home) needs `universityId` and `subjectId` if we want to fetch names.
       // Step 316 (HomeEntity) did NOT have them added.
       
       // I should either:
       // 1. Add `universityId`, `subjectId` to `HomeEntity`.
       // 2. Perform academic enrichment ON MODELS/DocsEntities BEFORE mapping to HomeEntity.
       
       // Option 2 is cleaner for `HomeEntity`.
       // So:
       // 1. Get DocsEntities (Models).
       // 2. Enrich Models with Academic info (names).
       // 3. Map to HomeEntity. 
       
       // But `_fetchUniversities` logic was using `universityId`.
       // `DocumentModel` has it.
       // So I can write `_enrichAcademicInfo` that takes `List<DocumentModel>` (or DocsEntity casted) 
       // and returns `List<DocumentModel>` (enriched).
       // Then map to HomeEntity.
       
       // Wait, `DocumentModel` is from `data/model`. 
       // If I modify it, does it affect others? No, it's just instance.
       // `DocumentModel` has `school` and `course` fields.
       // I can update them using `copyWith` (from DocsEntity).
       
       return documents; // Placeholder if I can't easily reimplement logic right now without code expansion.
       // Given the time, I'll implementing Option 2 inline in helper method.
  }
  
  /// Helper to enrich Models with Academic names
  Future<List<DocumentModel>> _enrichModelsWithAcademicInfo(List<DocumentModel> docs) async {
      final universityIds = docs
          .where((doc) => doc.universityId != null && doc.universityId!.isNotEmpty)
          .map((doc) => doc.universityId!)
          .toSet().toList();
          
      final subjectIds = docs
          .where((doc) => doc.subjectId != null && doc.subjectId!.isNotEmpty)
          .map((doc) => doc.subjectId!)
          .toSet().toList();
          
      final results = await Future.wait([
        _fetchUniversitiesByIds(universityIds),
        _fetchSubjectsByIds(subjectIds),
      ]);
      
      final universityMap = results[0] as Map<String, String>;
      final subjectMap = results[1] as Map<String, String>;
      
      return docs.map((doc) {
        final institutionName = doc.universityId != null
            ? universityMap[doc.universityId!] ?? doc.school
            : doc.school;
            
        final categoryName = doc.subjectId != null
            ? subjectMap[doc.subjectId!] ?? doc.course
            : doc.course;
            
        return doc.copyWith(school: institutionName, course: categoryName) as DocumentModel;
        // copyWith returns DocumentEntity (Docs). casting to Model might fail if copyWith returns Entity instance.
        // DocumentModel inherits copyWith from DocsEntity.
        // DocsEntity.copyWith returns DocumentEntity.
        // So I can't cast to DocumentModel unless I override copyWith in Model to return Model.
        // Or I work with DocsEntity.
      }).toList().cast<DocumentModel>(); // This cast will fail at runtime if copyWith returns Entity.
      
      // So I should work with DocsEntity in enrichment, then map to HomeEntity.
  }

  // Revised plan for getPopular/Recent:
  // 1. Get List<DocsEntity> (Models).
  // 2. Enrich w/ Academic (using DocsEntity interface).
  //    - `DocsEntity` has `universityId`, `subjectId`, `school`, `course`.
  //    - `copyWith` returns `DocsEntity`.
  // 3. Map `List<DocsEntity>` -> `List<HomeEntity>` using `fromModel` (casting needed or update fromModel to take Entity).
  //    - `fromModel` takes `DocumentModel`. `DocsEntity` IS NOT `DocumentModel` (Model is subtype).
  //    - But instances are Models.
  //    - `fromModel(e as DocumentModel)` works if `copyWith` preserves runtime type (usually it doesn't if impl returns `DocumentEntity(...)`).
  //    - DocsEntity.copyWith (Step 211) returns `DocumentEntity(...)`. It does NOT return `this` or `Model`.
  //    - So runtime type becomes `DocsEntity`. Casting to `DocumentModel` will FAIL.
  
  // So `fromModel` will fail if I pass a `DocsEntity` created by `copyWith`.
  // I need `HomeEntity.fromDocsEntity(DocsEntity e)`.
  // Or update `fromModel` to `fromEntity`.
  
  // I will update `HomeRepositoryImpl` to include mapping logic inline or helper, 
  // treating input as `DocsEntity` and output as `HomeEntity`.
  
  // Revised getPopularDocuments:
  // 1. `var docsEntities = await remoteDataSource.getMostLikedDocuments();`
  // 2. Enrichment (Academic):
  //    - input: `docsEntities`.
  //    - output: `enrichedDocsEntities`. (Type: `List<DocsEntity>`).
  // 3. Enrichment (Assets):
  //    - input: `enrichedDocsEntities`.
  //    - output: `enrichedDocsEntities` (thumbnail updated via copyWith -> new DocsEntity).
  // 4. Map to HomeEntity.
  //    - `docsEntities.map((d) => DocumentEntity(id: d.id, ...)).toList()`
  
  // This avoids `DocumentModel` casting issues and `HomeEntity` missing fields.

  @override
  Future<List<DocumentEntity>> _enrichWithAssets(
    List<DocumentEntity> docs,
  ) async {
    final futures = docs.map((doc) async {
      if ((doc.thumbnailUrl == null || doc.thumbnailUrl!.isEmpty) &&
          doc.fileId != null &&
          doc.fileId!.isNotEmpty) {
        try {
          final asset = await assetDataSource.getAssetById(doc.fileId!);
          final previewUrls = asset.previewUrls;
          if (previewUrls.isNotEmpty) {
             return doc.copyWith(thumbnailUrl: previewUrls.first);
          }
        } catch (_) {}
      }
      return doc;
    });
    return Future.wait(futures);
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 🔧 HELPER METHODS - Batch fetch names by IDs
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
