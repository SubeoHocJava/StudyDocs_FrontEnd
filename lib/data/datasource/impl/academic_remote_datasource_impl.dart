import 'dart:math';
import 'package:flutter/foundation.dart';

import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/features/explore/domain/entity/school_entity.dart';
import 'package:studydocs/features/subject_library/domain/entity/subject_entity.dart';
import '../academic_remote_datasource.dart';

class AcademicRemoteDataSourceImpl implements AcademicRemoteDataSource {
  final DioClient dioClient;

  AcademicRemoteDataSourceImpl({required this.dioClient});

  // --- EXPLORE / SCHOOL LOGIC (Real API) ---

  @override
  Future<SchoolEntity?> getCurrentUserSchool() async {
    // TODO: Implement real API
    await Future.delayed(const Duration(milliseconds: 200));
    return null;
  }

  @override
  Future<List<SchoolEntity>> searchSchools(String query) async {
    final response = await dioClient.get(
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
              .where((s) => s.name.toLowerCase().contains(query.trim().toLowerCase())) // Client-side fallback filter
              .toList();

      return allSchools;
    }
    
    throw ServerException('Failed to fetch schools', response.statusCode ?? 0);
  }

  // --- SUBJECT LOGIC (Real API) ---

  @override
  Future<List<SubjectEntity>> getSubjectsBySchool(String schoolId) async {
    // Direct call using University ID
    final resp = await dioClient.get(
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

    throw ServerException('Failed to fetch subjects', resp.statusCode ?? 0);
  }

  @override
  Future<List<SubjectEntity>> getAllSubjects() async {
    print('>>> DATASOURCE: getAllSubjects called with URL: ${ApiConstants.academicSubjects}');
    if (kDebugMode) {
      print('AcademicRemoteDataSourceImpl.getAllSubjects: Fetching all subjects');
    }
    final resp = await dioClient.get(ApiConstants.academicSubjects);

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

    throw ServerException('Failed to fetch all subjects', resp.statusCode ?? 0);
  }

  @override
  Future<List<String>> getSchools() async {
    final resp = await dioClient.get(ApiConstants.academicUniversitiesFilter);
    
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
    
    throw ServerException('Failed to fetch schools', resp.statusCode ?? 0);
  }

  //  NEW: Get University by ID
  @override
  Future<SchoolEntity> getUniversityById(String id) async {
    final path = '${ApiConstants.academicUniversityById}/$id';
    if (kDebugMode) {
      print('AcademicRemoteDataSourceImpl.getUniversityById: $path');
    }
    
    final response = await dioClient.get(path);

    if (response.isSuccess && response.data != null) {
      // Bóc tách linh hoạt: { data: { ... } } hoặc trực tiếp { ... }
      final data = (response.data is Map && response.data['data'] != null)
          ? response.data['data']
          : response.data;

      return SchoolEntity(
        id: data['id']?.toString() ?? '',
        name: data['name']?.toString() ?? '',
        shortName: data['slug']?.toString() ?? data['code']?.toString() ?? '',
      );
    }

    throw ServerException('University not found', response.statusCode);
  }

  // NEW: Get Subject by ID
  @override
  Future<SubjectEntity> getSubjectById(String id) async {
    final path = '${ApiConstants.academicSubjectById}/$id';
    if (kDebugMode) {
      print('AcademicRemoteDataSourceImpl.getSubjectById: $path');
    }

    final response = await dioClient.get(path);

    if (response.isSuccess && response.data != null) {
      final data = (response.data is Map && response.data['data'] != null)
          ? response.data['data']
          : response.data;
          
      return SubjectEntity(
        id: data['id']?.toString() ?? '',
        name: data['name']?.toString() ?? '',
      );
    }

    throw ServerException('Subject not found', response.statusCode);
  }
  @override
  Future<List<String>> getDocumentIds({String? universityId, String? subjectId}) async {
    final queryParams = <String, dynamic>{};
    if (universityId != null) queryParams['universityId'] = universityId;
    if (subjectId != null) queryParams['subjectId'] = subjectId;

    final response = await dioClient.get(
      ApiConstants.academicDocumentsFilter,
      queryParameters: queryParams,
    );

    if (response.isSuccess && response.data != null) {
      final data = response.data;
      // Bóc tách linh hoạt: { data: { documentIds: [] } } hoặc trực tiếp { documentIds: [] }
      final innerData = (data is Map && data['data'] != null) ? data['data'] : data;
      
      if (innerData is Map && innerData['documentIds'] != null) {
        final ids = List<String>.from(innerData['documentIds']);
        if (kDebugMode) {
          print('AcademicRemoteDataSourceImpl.getDocumentIds: Found ${ids.length} docs for uni:$universityId, sub:$subjectId');
        }
        return ids;
      }
      return [];
    }

    throw ServerException('Failed to fetch document IDs', response.statusCode);
  }
}

