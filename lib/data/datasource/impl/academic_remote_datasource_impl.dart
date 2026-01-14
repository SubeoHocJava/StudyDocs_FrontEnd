import 'package:dio/dio.dart';
import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/features/explore/domain/entity/school_entity.dart';
import 'package:studydocs/features/subject_library/domain/entity/subject_entity.dart';
import 'package:studydocs/services/token_storage_service.dart';
import '../academic_remote_datasource.dart';

class AcademicRemoteDataSourceImpl implements AcademicRemoteDataSource {
  final Dio _dio;
  final TokenStorageService _tokenStorage;

  AcademicRemoteDataSourceImpl({Dio? dio, TokenStorageService? tokenStorage})
    : _dio = dio ?? Dio(
        BaseOptions(
          baseUrl: ApiConstants.academicBaseUrl,
          connectTimeout: ApiConstants.connectTimeout,
          receiveTimeout: ApiConstants.receiveTimeout,
        ),
      ),
      _tokenStorage = tokenStorage ?? TokenStorageService();

  Future<void> _attachAuthHeader() async {
    final token = await _tokenStorage.getAuthorizationHeader();
    if (token != null) {
      _dio.options.headers['Authorization'] = token;
    }
  }

  // --- EXPLORE / SCHOOL LOGIC (Real API) ---

  @override
  Future<SchoolEntity?> getCurrentUserSchool() async {
    // TODO: Implement real API
    await Future.delayed(const Duration(milliseconds: 200));
    return null;
  }

  @override
  Future<List<SchoolEntity>> searchSchools(String query) async {
    await _attachAuthHeader();
    try {
      final response = await _dio.get(ApiConstants.academicUniversitiesFilter);

      if (response.statusCode == 200) {
        final body = response.data;
        final List data = body is Map && body['data'] != null ? body['data'] as List : [];

        final allSchools = data.map<SchoolEntity>((e) {
          return SchoolEntity(
            id: (e['id'] ?? '').toString(),
            name: (e['name'] ?? '').toString(),
            shortName: (e['slug'] ?? '').toString(),
          );
        }).where((s) => s.name.isNotEmpty).toList();

        if (query.trim().isEmpty) return allSchools;

        final lowerQuery = query.toLowerCase();
        return allSchools.where((s) {
          final matchName = s.name.toLowerCase().contains(lowerQuery);
          final matchShort = s.shortName?.toLowerCase().contains(lowerQuery) ?? false;
          return matchName || matchShort;
        }).toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  // --- SUBJECT LOGIC (Keeping mocks for now) ---

  @override
  Future<List<SubjectEntity>> getSubjectsBySchool(String schoolName) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final allSubjects = _getMockSubjects();
    
    // Simple filter logic for mocks based on hardcoded associations
    if (schoolName.contains('Nông Lâm')) {
      return allSubjects.where((s) => s.id == '1').toList();
    } else if (schoolName.contains('Bách Khoa')) {
      return allSubjects.where((s) => s.id == '2' || s.id == '3').toList();
    }
    return [];
  }

  @override
  Future<List<String>> getSchools() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      'Trường Đại học Nông Lâm Tp. HCM',
      'Trường Đại học Bách Khoa',
    ];
  }

  // --- PRIVATE MOCK HELPERS ---

  List<SubjectEntity> _getMockSubjects() {
    return [
      const SubjectEntity(
        id: '1',
        name: 'Lập trình .NET',
      ),
      const SubjectEntity(
        id: '2',
        name: 'Lập trình Mobile Flutter',
      ),
      const SubjectEntity(
        id: '3',
        name: 'Cấu trúc dữ liệu và giải thuật',
      ),
    ];
  }
}
