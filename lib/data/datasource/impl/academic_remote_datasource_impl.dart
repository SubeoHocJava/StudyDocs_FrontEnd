import 'package:studydocs/core/network/dio_client.dart';
import '../academic_remote_datasource.dart';

class AcademicRemoteDataSourceImpl implements AcademicRemoteDataSource {
  final DioClient _client;

  AcademicRemoteDataSourceImpl({DioClient? client}) : _client = client ?? DioClient();

  @override
  Future<dynamic> getUniversities({int? limit, String? search}) async {
    final Map<String, dynamic> params = {};
    if (limit != null) params['limit'] = limit;
    if (search != null && search.isNotEmpty) params['search'] = search;

    final response = await _client.get('education/universities', queryParameters: params);
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load universities');
  }

  @override
  Future<dynamic> getUniversityById(String id) async {
    final response = await _client.get('education/universities/$id');
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load university details');
  }

  @override
  Future<dynamic> getFacultiesByUniversity(String universityId) async {
    final response = await _client.get('education/universities/$universityId/faculties');
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load faculties');
  }

  @override
  Future<dynamic> getSubjects() async {
    final response = await _client.get('education/subjects');
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load subjects');
  }
}
