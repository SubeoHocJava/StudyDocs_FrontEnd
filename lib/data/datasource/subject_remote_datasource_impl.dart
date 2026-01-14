import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../features/subject_library/domain/entity/subject_entity.dart';
import 'subject_remote_datasource.dart';
import '../../services/token_storage_service.dart';

/// Real implementation of SubjectRemoteDataSource using Dio to call Academic Service
class SubjectRemoteDataSourceImpl implements SubjectRemoteDataSource {
  final Dio _dio;
  final String baseUrl;

  SubjectRemoteDataSourceImpl({
    Dio? dio,
    this.baseUrl = ApiConstants.academicBaseUrl,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: ApiConstants.connectTimeout,
             ),
           );

  Future<void> _attachAuthHeader() async {
    final token = await TokenStorageService().getAuthorizationHeader();
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

  @override
  Future<List<String>> getSchools() async {
    await _attachAuthHeader();
    try {
      final resp = await _dio.get(ApiConstants.academicUniversitiesFilter);
      if (resp.statusCode == 200) {
        final body = resp.data;
        final data =
            body is Map && body['data'] != null ? body['data'] as List : [];
        return data
            .map<String>((e) => (e['name'] ?? '').toString())
            .where((s) => s.isNotEmpty)
            .toList();
      }
    } catch (e) {
      // ignore and return empty list on error
    }
    return [];
  }

  @override
  Future<List<SubjectEntity>> getSubjectsBySchool(String schoolName) async {
    await _attachAuthHeader();

    // initial slug fallback
    String slug = _slugify(schoolName);

    try {
      final uniResp = await _dio.get(ApiConstants.academicUniversitiesFilter);
      if (uniResp.statusCode == 200) {
        final body = uniResp.data;
        final uniList =
            body is Map && body['data'] != null ? body['data'] as List : [];

        // try to find university id or slug by matching name
        String? foundUniversityId;
        for (final u in uniList) {
          final name = (u['name'] ?? '').toString();
          final candidateId = (u['id'] ?? '').toString();
          final candidateSlug = (u['slug'] ?? '').toString();
          if (name.isNotEmpty) {
            if (name.toLowerCase() == schoolName.toLowerCase() ||
                name.toLowerCase().contains(schoolName.toLowerCase()) ||
                schoolName.toLowerCase().contains(name.toLowerCase())) {
              if (candidateId.isNotEmpty) {
                foundUniversityId = candidateId;
                break;
              }
              if (candidateSlug.isNotEmpty) {
                slug = candidateSlug;
              }
            }
          }
        }

        // if we found id, call subjects by universityId
        if (foundUniversityId != null && foundUniversityId.isNotEmpty) {
          final resp = await _dio.get(
            ApiConstants.academicSubjectsFilter,
            queryParameters: {
              'universityId': foundUniversityId,
              'isActive': true,
            },
          );
          if (resp.statusCode == 200) {
            final body = resp.data;
            final data =
                body is Map && body['data'] != null ? body['data'] as List : [];
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
        }
      }

      // fallback to calling by slug
      final fallbackResp = await _dio.get(
        ApiConstants.academicSubjectsFilter,
        queryParameters: {'universitySlug': slug},
      );
      if (fallbackResp.statusCode == 200) {
        final body = fallbackResp.data;
        final data =
            body is Map && body['data'] != null ? body['data'] as List : [];
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
      // ignore and fallback
    }

    return [];
  }
}
