import 'package:file_picker/src/platform_file.dart';

import '../upload_file_repository.dart';

class UpLoadFileRepositoryImpl implements UploadFileRepository {
  @override
  Future<bool> uploadDocument({required String filePath, required String school,
    required String subject,
    required String fileName,
    required String year,
    required String description}) async {
    print("Đã gửi request thành công");
   return true;
  }
  // final String apiUrl = "https://your-api.com/upload";
  // @override
  // Future<bool> uploadDocument({
  //   required String filePath,
  //   required String school,
  //   required String subject,
  //   required String fileName,
  //   required String year,
  //   required String description,
  // }) async {
  //   try {
  //     final request = http.MultipartRequest("POST", Uri.parse(apiUrl));
  //
  //     request.fields['school'] = school;
  //     request.fields['subject'] = subject;
  //     request.fields['fileName'] = fileName;
  //     request.fields['year'] = year;
  //     request.fields['description'] = description;
  //
  //     request.files.add(
  //       await http.MultipartFile.fromPath('file', filePath),
  //     );
  //
  //     final res = await request.send();
  //     return res.statusCode == 200;
  //   } catch (e) {
  //     return false;
  //   }
  // }

}
