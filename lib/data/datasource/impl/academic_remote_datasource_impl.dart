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

    final response = await _client.get('education/academics/universities', queryParameters: params);
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load universities');
  }

  @override
  Future<dynamic> getUniversityById(String id) async {
    final response = await _client.get('education/academics/universities/$id');
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load university details');
  }

  @override
  Future<dynamic> getFacultiesByUniversity(String universityId) async {
    final response = await _client.get('education/academics/universities/$universityId/faculties');
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load faculties');
  }

  @override
  Future<dynamic> getDepartmentsByFaculty(String facultyId) async {
    final response = await _client.get('education/academics/faculties/$facultyId/departments');
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load departments');
  }

  @override
  Future<dynamic> getSubjects({int? departmentId}) async {
    final Map<String, dynamic> params = {};
    if (departmentId != null) params['departmentId'] = departmentId;
    
    final response = await _client.get('education/academics/subjects', queryParameters: params);
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load subjects');
  }

  @override
  Future<dynamic> getSubjectsByDepartment(String departmentId) async {
    final response = await _client.get('education/academics/departments/$departmentId/subjects');
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load subjects by department');
  }

  @override
  Future<dynamic> getPublicUniversityById(String id) async {
    final response = await _client.get('education/academics/public/universities/id/$id');
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load public university details');
  }

  @override
  Future<dynamic> getPublicSubjectById(String id) async {
    final response = await _client.get('education/academics/public/subjects/id/$id');
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load public subject details');
  }

  @override
  Future<dynamic> getAcademicDocuments({String? query}) async {
    final Map<String, dynamic> params = {};
    if (query != null && query.isNotEmpty) params['q'] = query;
    
    final response = await _client.get('education/academics/documents', queryParameters: params);
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load academic documents');
  }

  @override
  Future<dynamic> createUniversity(Map<String, dynamic> request) async {
    final response = await _client.post('education/academics/universities', data: request);
    if (response.isSuccess) return response.data;
    throw Exception('Failed to create university');
  }

  @override
  Future<dynamic> createSubject(Map<String, dynamic> request) async {
    final response = await _client.post('education/academics/subjects', data: request);
    if (response.isSuccess) return response.data;
    throw Exception('Failed to create subject');
  }

  @override
  Future<dynamic> createSubjectForDepartment(String departmentId, Map<String, dynamic> request) async {
    final response = await _client.post('education/academics/departments/$departmentId/subjects', data: request);
    if (response.isSuccess) return response.data;
    throw Exception('Failed to create subject for department');
  }
}
