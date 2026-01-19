import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/model/request/upload_document_request.dart';

import '../../core/constants/api_constants.dart';

/// ===============================
/// ABSTRACT INTERFACE
/// ===============================
abstract interface class UploadRemoteDataSource {
  Future<bool> uploadDocument(UploadDocumentRequest request, File file);
}

/// ===============================
/// IMPLEMENTATION
/// ===============================
class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final DioClient dioClient;

  UploadRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<bool> uploadDocument(UploadDocumentRequest request, File file) async {
    try {
      final formData = FormData.fromMap({
        'data': jsonEncode(request.toJson()), // Send metadata as JSON string
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split(Platform.pathSeparator).last,
        ),
      });

      final response = await dioClient.post(
        ApiConstants.uploadDocument,
        data: formData,
      );

      // Relaxed success check: Any 2xx status is success
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return true;
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
