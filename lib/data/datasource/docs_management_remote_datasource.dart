import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../features/docs/data/model/document_model.dart';
import '../../features/docs/domain/entity/document_entity.dart';

abstract class DocsManagementRemoteDataSource {
  Future<List<DocumentEntity>> getMyDocuments();
  Future<void> deleteDocument(String id);
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
  Future<void> deleteDocument(String id) async {
    await dioClient.delete(
      '${ApiConstants.documentServiceUrl}/documents/user/$id',
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
    final metadataMap = {
      'title': metadata.title,
      'description': metadata.description,
      'schoolYear': metadata.year,
      // userId is typically extracted from Token in Backend, 
      // but if Request Body requires it explicitly and Backend doesn't extracting it from Token for this specific DTO,
      // we might need to send it. Use a placeholder if not available in Entity.
      // However, usually User endpoints use the Token's UserID.
      'universityId': null, 
      'subjectId': null,    
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
          contentType: DioMediaType.parse("application/json"),
      ),
    });

    await dioClient.post(
      '${ApiConstants.documentServiceUrl}/documents/user',
      data: formData,
    );
  }
}
