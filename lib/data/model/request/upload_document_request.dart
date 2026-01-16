class UploadDocumentRequest {
  final String title;
  final String description;
  final String institution; // School
  final String category; // Subject
  final String academicYear;

  UploadDocumentRequest({
    required this.title,
    required this.description,
    required this.institution,
    required this.category,
    required this.academicYear,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'institution': institution,
      'category': category,
      'academicYear': academicYear,
    };
  }
}
