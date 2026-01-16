import 'package:studydocs/data/datasource/academic_remote_datasource.dart';
import 'package:studydocs/data/datasource/document_remote_datasource.dart';
import 'package:studydocs/features/home/domain/entity/document_entity.dart';
import 'package:studydocs/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final DocumentRemoteDataSource remoteDataSource;
  final AcademicRemoteDataSource academicDataSource;  // ✅ New dependency

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.academicDataSource,  // ✅ Inject Academic DataSource
  });

  @override
  Future<List<DocumentEntity>> getDocuments() async {
    try {
      final models = await remoteDataSource.getDocuments();
      return models.map((model) => DocumentEntity.fromModel(model)).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get documents - $e');
    }
  }

  @override
  Future<List<DocumentEntity>> getPopularDocuments() async {
    try {
      // 1. Fetch documents với IDs từ API
      final documents = await remoteDataSource.getPopularDocuments();

      // 2. Extract unique university IDs và subject IDs
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

      // 3. Batch fetch universities và subjects (parallel)
      final results = await Future.wait([
        _fetchUniversitiesByIds(universityIds),
        _fetchSubjectsByIds(subjectIds),
      ]);

      final universityMap = results[0] as Map<String, String>;
      final subjectMap = results[1] as Map<String, String>;

      // 4. Map documents → entities với tên đầy đủ
      return documents.map((doc) {
        final institutionName = doc.universityId != null
            ? universityMap[doc.universityId!] ?? doc.institution ?? 'Unknown University'
            : doc.institution ?? 'Unknown University';

        final categoryName = doc.subjectId != null
            ? subjectMap[doc.subjectId!] ?? doc.category ?? 'Unknown Subject'
            : doc.category ?? 'Unknown Subject';

        return DocumentEntity(
          id: doc.id,
          title: doc.title,
          description: doc.description ?? '',
          institution: institutionName,     //  Tên đầy đủ từ Academic API
          category: categoryName,           //  Tên đầy đủ từ Academic API
          academicYear: doc.createdAt ?? '',
          viewCount: doc.viewCount,
          downloadCount: doc.downloadCount,
          likesCount: doc.likesCount,
          commentsCount: doc.commentsCount,
          rating: doc.rating,
          thumbnailUrl: doc.thumbnailUrl,
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
      final documents = await remoteDataSource.getRecentDocuments();

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

      final universityMap = results[0] as Map<String, String>;
      final subjectMap = results[1] as Map<String, String>;

      return documents.map((doc) {
        final institutionName = doc.universityId != null
            ? universityMap[doc.universityId!] ?? doc.institution ?? 'Unknown University'
            : doc.institution ?? 'Unknown University';

        final categoryName = doc.subjectId != null
            ? subjectMap[doc.subjectId!] ?? doc.category ?? 'Unknown Subject'
            : doc.category ?? 'Unknown Subject';

        return DocumentEntity(
          id: doc.id,
          title: doc.title,
          description: doc.description ?? '',
          institution: institutionName,
          category: categoryName,
          academicYear: doc.createdAt ?? '',
          viewCount: doc.viewCount,
          downloadCount: doc.downloadCount,
          likesCount: doc.likesCount,
          commentsCount: doc.commentsCount,
          rating: doc.rating,
          thumbnailUrl: doc.thumbnailUrl,
        );
      }).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get recent documents - $e');
    }
  }

  @override
  Future<List<DocumentEntity>> searchDocuments(String query) async {
    try {
      final models = await remoteDataSource.searchDocuments(query);
      return models.map((model) => DocumentEntity.fromModel(model)).toList();
    } catch (e) {
      throw Exception('Repository: Failed to search documents - $e');
    }
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