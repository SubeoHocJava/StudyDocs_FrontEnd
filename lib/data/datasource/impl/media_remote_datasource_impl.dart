import 'package:studydocs/core/network/dio_client.dart';
import '../media_remote_datasource.dart';

class MediaRemoteDataSourceImpl implements MediaRemoteDataSource {
  final DioClient _client;

  MediaRemoteDataSourceImpl({DioClient? client}) : _client = client ?? DioClient();

  @override
  Future<dynamic> getUploadUrl(String fileName, String fileType, int fileSize) async {
    final response = await _client.post('media/upload/init', data: {
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
    });
    if (response.isSuccess) return response.data;
    throw Exception('Failed to initialize upload');
  }
}
