
import '../data/upload_file_repository.dart';

class UploadFileUseCase{
  final UploadFileRepository repository;

  UploadFileUseCase( {required  this.repository});

  Future<bool> call({
    required String filePath,
    required String schoolId,
    required String subjectId,
    required String fileName,
    required String year,
    required String description,
  }) async {
    return await repository.uploadFile(
      filePath: filePath,
      schoolId: schoolId,
      subjectId: subjectId,
      fileName: fileName,
      year: year,
      description: description,
    );
  }
}