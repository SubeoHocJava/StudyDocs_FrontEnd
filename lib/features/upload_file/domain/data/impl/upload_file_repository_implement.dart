import 'dart:io';

import '../../../../../core/network/dio_client.dart';
import '../../../../../data/datasource/upload_datasource.dart';
import '../../../../../data/model/request/upload_document_request.dart';
import '../upload_file_repository.dart';

class UpLoadFileRepositoryImpl implements UploadFileRepository {
  late final UploadRemoteDataSource uploadRemoteDataSource;

  UpLoadFileRepositoryImpl() {
    final dioClient = DioClient();
    uploadRemoteDataSource = UploadRemoteDataSourceImpl(dioClient: dioClient);
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
      final request = UploadDocumentRequest(
        title: fileName,
        description: description,
        institution: school,
        category: subject,
        academicYear: year,
      );
      final file = File(filePath);

      await uploadRemoteDataSource.uploadDocument(request, file);

      return true;
    } catch (e) {
      print('Upload error: $e');
      return false;
    }
  }
}

