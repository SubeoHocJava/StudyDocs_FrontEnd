import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/school.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/subject.dart';

class UploadRequest {
  final String? fileName;
  final String schoolId;
  final String subjectId;
  final String title;
  final String year;
  final String description;

  const UploadRequest({
    required this.fileName,
    required this.schoolId,
    required this.subjectId,
    required this.title,
    required this.year,
    required this.description,
  });
}

/// Repository cho thao tác upload tài liệu (trường, môn, submit form).
abstract interface class UploadRepository {
  Future<List<School>> getSchools();

  Future<List<Subject>> getSubjectsBySchool(String schoolId);

  Future<void> submitUpload(UploadRequest request);
}

