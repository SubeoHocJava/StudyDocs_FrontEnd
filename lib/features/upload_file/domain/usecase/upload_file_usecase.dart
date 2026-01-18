
import '../data/upload_file_repository.dart';

class UploadFileUseCase{
  final UploadFileRepository repository;

  UploadFileUseCase( {required  this.repository});

  Future<bool> call({
    required String filePath,
    required String school,
    required String subject,
    required String fileName,
    required String year,
    required String description,
  }) async {
    return await repository.uploadDocument(
      filePath: filePath,
      school: school,
      subject: subject,
      fileName: fileName,
      year: year,
      description: description,
    );
  }
}