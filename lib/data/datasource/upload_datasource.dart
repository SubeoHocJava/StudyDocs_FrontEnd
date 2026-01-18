


/// ===============================
/// ABSTRACT INTERFACE
/// ===============================
// abstract interface class UploadFile {
//   Future<ApiResponse> uploadDocument({
//     required String filePath,
//     required String school,
//     required String subject,
//     required String fileName,
//     required String year,
//     required String description,
//     String? traceId,
//   });
// }

/// ===============================
/// IMPLEMENTATION
/// ===============================
// class UploadFileImpl implements UploadFile {
//   static UploadFileImpl? _instance;
//   final DioClient dioClient;
//
//   /// Private constructor
//   UploadFileImpl._({required this.dioClient});
//
//   /// Singleton factory
//   factory UploadFileImpl({required DioClient dioClient}) {
//     return _instance ??= UploadFileImpl._(dioClient: dioClient);
//   }
  //
  // @override
  // Future<ApiResponse> uploadDocument({
  //   required String filePath,
  //   required String school,
  //   required String subject,
  //   required String fileName,
  //   required String year,
  //   required String description,
  //   String? traceId,
  // }) async {
  //   final file = File(filePath);
  //
  //   final formData = FormData.fromMap({
  //     'school': school,
  //     'subject': subject,
  //     'fileName': fileName,
  //     'year': year,
  //     'description': description,
  //     'file': await MultipartFile.fromFile(
  //       file.path,
  //       filename: fileName,
  //     ),
  //   });
  //
  //   return dioClient.post(
  //     ApiConstants.uploadDocument,
  //     data: formData,
  //     data: Options(
  //       contentType: 'multipart/form-data',
  //     ),
  //   );
  // }
// }
