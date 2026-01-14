import 'dart:io';
import 'package:dio/dio.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../data/datasource/user_datasource.dart';
import '../upload_file_repository.dart';

class UpLoadFileRepositoryImpl implements UploadFileRepository {
  late final UserDataSource userDataSource;

  UpLoadFileRepositoryImpl() {
    userDataSource = UserDataSourceImpl(
      dioClient: DioClient(),
    );
  }

  final String apiUrl = "https://your-api.com/upload";

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
      final formData = FormData.fromMap({
        'school': school,
        'subject': subject,
        'fileName': fileName,
        'year': year,
        'description': description,
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });
      final response = await userDataSource.uploadImage("a", formData);
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Upload error: $e');
      return false;
    }
  }
}
