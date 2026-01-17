import 'dart:io';

import 'package:studydocs/data/datasource/upload_datasource.dart';

import '../../../../../data/datasource/document_remote_datasource.dart';
import '../../../../../data/datasource/impl/document_remote_datasource_impl.dart';
import '../../../../../core/network/dio_client.dart';
import '../upload_file_repository.dart';
import '../../../../../data/model/request/upload_document_request.dart';

class UpLoadFileRepositoryImpl implements UploadFileRepository {
  late final UploadRemoteDataSource uploadDatasource;

  UpLoadFileRepositoryImpl() {
    final dioClient = DioClient();
    uploadDatasource = UploadRemoteDataSourceImpl(
      dioClient: dioClient,
    );
  }

  @override
  Future<bool> uploadDocument({
    required String filePath,
    required String school,
    required String subject,
    required String fileName,
    required String year,
    required String description,
  }) async {
    try {
      /// 1. Tạo File
      final file = File(filePath);

      /// 2. Map sang UploadDocumentRequest
      final request = UploadDocumentRequest(
        title: fileName,
        description: description,
        institution: school,
        category: subject,
        academicYear: year,
      );

      /// 3. Gọi RemoteDataSource
      await uploadDatasource.uploadDocument(request, file);

      return true;
    } catch (e) {
      print('Upload error: $e');
      return false;
    }
  }
}
