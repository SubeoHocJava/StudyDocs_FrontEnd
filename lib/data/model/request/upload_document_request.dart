class UploadDocumentRequest {
  final String title;
  final String description;
  final String? universityId; // School ID (not name!)
  final String? subjectId;    // Subject ID (not name!)
  final String academicYear;

  UploadDocumentRequest({
    required this.title,
    required this.description,
    this.universityId,
    this.subjectId,
    required this.academicYear,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'universityId': universityId,
      'subjectId': subjectId,
      'academicYear': academicYear,
    };
  }
}
