abstract interface class MediaRemoteDataSource {
  Future<dynamic> getUploadUrl(String fileName, String fileType, int fileSize);
}
