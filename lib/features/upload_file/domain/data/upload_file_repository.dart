
abstract class UploadFileRepository{
  Future<bool> uploadFile({
    required String filePath,
    required String schoolId,
    required String subjectId,
    required String fileName,
    required String year,
    required String description,
  });

}