import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../features/docs/data/model/document_model.dart';
import '../../features/docs/domain/entity/document_entity.dart';

abstract class DocsManagementRemoteDataSource {
  Future<List<DocumentEntity>> getMyDocuments();
  Future<List<DocumentEntity>> getAllDocuments();
  Future<void> deleteDocument(String id);
  Future<void> deleteAdminDocument(String id);
  Future<void> updateDocument(String id, DocumentEntity updatedDoc);
  Future<void> uploadDocument(dynamic file, DocumentEntity metadata);
}

class DocsManagementRemoteDataSourceImpl implements DocsManagementRemoteDataSource {
  final DioClient dioClient;

  DocsManagementRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<DocumentEntity>> getMyDocuments() async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.documentServiceUrl}/documents/user/me',
      );
      // Assuming response.data is List or Page
      // Adjust based on ApiResponse structure
      // Backend returns ApiResponse<List<DocumentResponse>> or Page
      final data = response.data; 
      if (data is List) {
        return data.map((json) => DocumentModel.fromJson(json)).toList();
      } else if (data is Map && data.containsKey('content')) {
         // Handle Page object
         final content = data['content'] as List;
         return content.map((json) => DocumentModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch my documents: $e');
    }
  }

  @override
  Future<List<DocumentEntity>> getAllDocuments() async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.documentServiceUrl}/internal/documents', // internal API
      );
      final data = response.data; 
      // Assuming structure is similar to Page/List
      if (data is Map && data.containsKey('content')) {
         final content = data['content'] as List;
         return content.map((json) => DocumentModel.fromJson(json)).toList();
      } else if (data is List) {
         return data.map((json) => DocumentModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch all documents: $e');
    }
  }

  @override
  Future<void> deleteDocument(String id) async {
    if (id.isEmpty) {
      throw Exception("Document ID cannot be empty");
    }
    await dioClient.delete(
      '${ApiConstants.documentServiceUrl}/documents/user/$id',
    );
  }

  @override
  Future<void> deleteAdminDocument(String id) async {
    if (id.isEmpty) {
      throw Exception("Document ID cannot be empty");
    }
    await dioClient.delete(
      '${ApiConstants.documentServiceUrl}/internal/documents/$id',
    );
  }

  @override
  Future<void> updateDocument(String id, DocumentEntity updatedDoc) async {
    await dioClient.put(
      '${ApiConstants.documentServiceUrl}/documents/user/$id',
      data: {
        'title': updatedDoc.title,
        'description': updatedDoc.description, 
        'schoolYear': updatedDoc.year,
      },
    );
  }

  @override
  Future<void> uploadDocument(dynamic file, DocumentEntity metadata) async {
    // Construct JSON data matching UploadDocumentRequest
    // Try to parse School/Course as UUIDs if user entered them manually
    String? universityId;
    if (metadata.school.length == 36) {
       universityId = metadata.school;
    }
    String? subjectId;
    if (metadata.course.length == 36) {
       subjectId = metadata.course;
    }

    final metadataMap = {
      'title': metadata.title,
      'description': metadata.description,
      'schoolYear': metadata.year,
      'universityId': universityId, 
      'subjectId': subjectId,    
    };

    MultipartFile multipartFile;
    if (file.bytes != null) {
      multipartFile = MultipartFile.fromBytes(file.bytes!, filename: file.name);
    } else {
      multipartFile = await MultipartFile.fromFile(file.path!, filename: file.name);
    }

    FormData formData = FormData.fromMap({
      'file': multipartFile,
      'data': MultipartFile.fromString(
          jsonEncode(metadataMap),
          contentType: MediaType.parse("application/json"),
      ),
    });

    await dioClient.post(
      '${ApiConstants.documentServiceUrl}/documents/user',
      data: formData,
    );
  }
}
