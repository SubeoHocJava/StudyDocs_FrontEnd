import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/model/api_response.dart';
import 'package:studydocs/data/model/request/upload_document_request.dart';

import '../../core/constants/api_constants.dart';
import '../../features/docs/data/model/document_model.dart';

/// ===============================
/// ABSTRACT INTERFACE
/// ===============================
abstract interface class UploadRemoteDataSource {
  Future<DocumentModel> uploadDocument(
    UploadDocumentRequest request,
    File file,
  );
}

/// ===============================
/// IMPLEMENTATION
/// ===============================
class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final DioClient dioClient;

  UploadRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<DocumentModel> uploadDocument(
    UploadDocumentRequest request,
    File file,
  ) async {
    try {
      final formData = FormData.fromMap({
        'data': jsonEncode(request.toJson()), // Send metadata as JSON string
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await dioClient.post(
        ApiConstants.uploadDocument,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        final apiResponse = ApiResponse<DocumentModel>.fromJson(
          response.data,
          (json) => DocumentModel.fromJson(json),
        );

        if (apiResponse.isSuccess && apiResponse.data != null) {
          return apiResponse.data!;
        }
      }

      throw ServerException(
        'Failed to upload document',
        response.statusCode ?? 0,
      );
    } catch (e) {
      throw ServerException('Failed to upload document: $e', 0);
    }
  }
}
