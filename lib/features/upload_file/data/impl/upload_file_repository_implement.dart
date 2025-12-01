import 'package:file_picker/src/platform_file.dart';

import '../upload_file_repository.dart';

class UpLoadFileRepositoryImpl implements UploadFileRepository {
  @override
  void upload(
    List<PlatformFile> file,
    String school,
    String subject,
    String fileName,
    String year,
    String description,
  ) {
   print("Post file đến server upload file");
  }
}
