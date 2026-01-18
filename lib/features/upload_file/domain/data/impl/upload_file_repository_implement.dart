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
  Future<bool> uploadFile({
    required String filePath,
    required String schoolId,
    required String subjectId,
    required String fileName,
    required String year,
    required String description,
  }) async {
    try {
      print(' [UPLOAD] Starting upload...');
      print('  schoolId: "$schoolId" (length: ${schoolId.length})');
      print('  subjectId: "$subjectId" (length: ${subjectId.length})');
      print('  fileName: $fileName');
      
      /// 1. Tạo File
      final file = File(filePath);

      /// 2. Map sang UploadDocumentRequest với IDs
      final request = UploadDocumentRequest(
        title: fileName,
        description: description,
        universityId: schoolId.isNotEmpty ? schoolId : null,
        subjectId: subjectId.isNotEmpty ? subjectId : null,
        academicYear: year,
      );
      
      print('  Request JSON: ${request.toJson()}');

      /// 3. Gọi RemoteDataSource
      await uploadDatasource.uploadDocument(request, file);

      print(' [UPLOAD] Success!');
      return true;
    } catch (e) {
      print(' [UPLOAD] Error: $e');
      return false;
    }
  }
}
