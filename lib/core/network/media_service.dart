import 'dart:io';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'dio_client.dart';

class MediaService {
  final DioClient _dioClient;

  MediaService(this._dioClient);

  /// Trả về mediaId nếu upload thành công, null nếu thất bại
  Future<int?> uploadMedia({
    required File file,
    required String ownerId,
    required String ownerType,
    required String mediaType, // 'IMAGE', 'VIDEO', 'DOCUMENT'
  }) async {
    try {
      final fileName = file.path.split('/').last;
      
      // 1. Gọi API Gateway -> Media Service để lấy URL Upload của Cloudinary
      final idempotencyKey = DateTime.now().millisecondsSinceEpoch.toString();
      final initResponse = await _dioClient.post(
        MediaEndpoints.initUpload,
        data: {
          'fileName': fileName,
          'mediaType': mediaType,
          'ownerId': ownerId,
          'ownerType': ownerType,
        },
        options: Options(
          headers: {'Idempotency-Key': idempotencyKey},
        ),
      );

      final data = initResponse.data;
      if (data == null) return null;

      final uploadUrl = data['uploadUrl'];
      final mediaId = data['mediaId'];

      if (uploadUrl == null || mediaId == null) {
        throw Exception("Invalid response from init-upload");
      }

      // 2. Upload trực tiếp file lên Cloudinary thông qua URL đã được ký
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      // Tạo một instance Dio mới để gọi ra ngoài (không đính kèm Token của hệ thống)
      final externalDio = Dio();
      final uploadResponse = await externalDio.post(
        uploadUrl,
        data: formData,
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (uploadResponse.statusCode != 200) {
        throw Exception("Cloudinary upload failed: ${uploadResponse.data}");
      }

      // 3. Gọi API xác nhận hoàn tất Upload
      await _dioClient.put('${MediaEndpoints.completeUpload.replaceAll("complete-upload", "")}$mediaId/complete-upload');

      return mediaId;
    } catch (e) {
      print("Media upload error: $e");
      return null;
    }
  }
}
