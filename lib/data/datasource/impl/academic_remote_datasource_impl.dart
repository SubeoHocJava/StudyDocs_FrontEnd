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
    : _dio =
          dio ??
          Dio(
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

  String _slugify(String input) {
    // basic slugify: lowercase, replace spaces with hyphen, remove common diacritics
    var s = input.trim().toLowerCase();
    // remove Vietnamese diacritics (basic mapping)
    const withDia =
        'áàảãạâấầẩẫậăắằẳẵặéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđ';
    const withoutDia =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';
    for (var i = 0; i < withDia.length; i++) {
      s = s.replaceAll(withDia[i], withoutDia[i]);
    }
    s = s.replaceAll(RegExp(r"[^a-z0-9\s-]"), '');
    s = s.replaceAll(RegExp(r"\s+"), '-');
    s = s.replaceAll(RegExp(r"-+"), '-');
    return s;
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
      final response = await _dio.get(
        ApiConstants.academicUniversitiesFilter,
        queryParameters: query.trim().isNotEmpty ? {'query': query} : null,
      );

      if (response.statusCode == 200 && response.data != null) {
        final body = response.data;
        // Linh hoạt handle: {data: [...]} hoặc thẳng [...]
        final List data =
            (body is Map && body['data'] != null)
                ? body['data'] as List
                : (body is List ? body : []);

        final allSchools =
            data
                .map<SchoolEntity>((e) {
                  return SchoolEntity(
                    id: (e['id'] ?? '').toString(),
                    name: (e['name'] ?? '').toString(),
                    shortName: (e['slug'] ?? e['shortName'] ?? '').toString(),
                  );
                })
                .where((s) => s.name.isNotEmpty)
                .toList();

        return allSchools;
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  // --- SUBJECT LOGIC (Real API) ---

  @override
  Future<List<SubjectEntity>> getSubjectsBySchool(String schoolId) async {
    await _attachAuthHeader();
    try {
      // Direct call using University ID
      final resp = await _dio.get(
        ApiConstants.academicSubjectsFilter,
        queryParameters: {'universityId': schoolId, 'isActive': true},
      );
      if (resp.statusCode == 200) {
        final body = resp.data;
        final data =
            (body is Map && body['data'] != null)
                ? body['data'] as List
                : (body is List ? body : []);

        return data
            .map<SubjectEntity>(
              (item) => SubjectEntity(
                id: (item['id'] ?? '').toString(),
                name: (item['name'] ?? item['title'] ?? '').toString(),
              ),
            )
            .where((s) => s.id.isNotEmpty && s.name.isNotEmpty)
            .toList();
      }
    } catch (e) {
      // ignore
    }

    return [];
  }

  @override
  Future<List<String>> getSchools() async {
    await _attachAuthHeader();
    try {
      final resp = await _dio.get(ApiConstants.academicUniversitiesFilter);
      if (resp.statusCode == 200) {
        final body = resp.data;
        final data =
            (body is Map && body['data'] != null)
                ? body['data'] as List
                : (body is List ? body : []);
        return data
            .map<String>((e) => (e['name'] ?? '').toString())
            .where((s) => s.isNotEmpty)
            .toList();
      }
    } catch (e) {
      // ignore
    }
    return [];
  }
}
