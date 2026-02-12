import 'package:studydocs/core/feat/document/overview/domain/entity/course_info.dart';
import 'package:studydocs/core/feat/document/overview/domain/entity/school_info.dart';

class DocumentOverview {
  final String id;
  final String title;
  final SchoolInfo schoolInfo;
  final CourseInfo courseInfo;
  bool isSaved;

  DocumentOverview({
    required this.id,
    required this.title,
    required this.schoolInfo,
    required this.courseInfo,
    required this.isSaved,
  });

  DocumentOverview copyWith(bool isSaved) {
    this.isSaved = isSaved;
    return this;
  }
}
