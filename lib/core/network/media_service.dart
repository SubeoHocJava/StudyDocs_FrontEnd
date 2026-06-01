import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'dio_client.dart';

class MediaService {
  final DioClient _dioClient;

  MediaService(this._dioClient);

  /// Trả về mediaId nếu upload thành công, null nếu thất bại
  Future<int?> uploadMedia({
    required PlatformFile file,
    required String ownerId,
    required String ownerType,
    required String mediaType, // 'IMAGE', 'VIDEO', 'DOCUMENT'
  }) async {
    final fileName = file.name;
      
      // 1. Gọi API Gateway -> Media Service để lấy URL Upload của Cloudinary
      final idempotencyKey = DateTime.now().millisecondsSinceEpoch.toString();
      final initResponse = await _dioClient.dio.post(
        MediaEndpoints.initUpload,
        data: {
          'fileName': fileName,
          'contentType': 'application/octet-stream', 
          'sizeBytes': file.size,
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
        'file': MultipartFile.fromBytes(file.bytes!, filename: fileName),
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
      await _dioClient.dio.put(
        '${MediaEndpoints.completeUpload.replaceAll("complete-upload", "")}$mediaId/complete-upload',
        data: uploadResponse.data,
      );

      return mediaId;
  }
}
