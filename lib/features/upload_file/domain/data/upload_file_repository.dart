

abstract class UploadFileRepository{
  Future<bool> uploadDocument({
    required String filePath,
    required String school,
    required String subject,
    required String fileName,
    required String year,
    required String description,
  });

}