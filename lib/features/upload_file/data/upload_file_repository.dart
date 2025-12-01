import 'package:file_picker/src/platform_file.dart';

abstract class UploadFileRepository{
  void upload(List<PlatformFile> file, String school, String subject, String fileName, String year, String description) {

  }

}