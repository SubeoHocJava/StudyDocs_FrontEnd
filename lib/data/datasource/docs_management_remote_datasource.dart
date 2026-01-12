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
  Future<void> uploadDocument(File file, DocumentEntity metadata);
}

class DocsManagementRemoteDataSourceImpl implements DocsManagementRemoteDataSource {
  final DioClient dioClient;

  DocsManagementRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<DocumentEntity>> getMyDocuments() async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.documentServiceUrl}/documents/user',
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
     // TODO: Implement Update API when available or if using same endpoint
  }

  @override
  Future<void> uploadDocument(File file, DocumentEntity metadata) async {
    String fileName = file.path.split('/').last;
    
    // Construct JSON data matching UploadDocumentRequest
      'title': metadata.title,
      'description': metadata.title, // or description field if added
      'schoolYear': metadata.year,
      'universityId': null, // TODO: Bind to UI selection
      'subjectId': null,    // TODO: Bind to UI selection
    };

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      'data': jsonEncode(metadataMap),
    });

    await dioClient.post(
      '${ApiConstants.documentServiceUrl}/documents/user/upload',
      data: formData,
    );
  }
}
