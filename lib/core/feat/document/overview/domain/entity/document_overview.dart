import 'package:equatable/equatable.dart';
import 'package:studydocs/core/feat/document/overview/domain/entity/course_info.dart';
import 'package:studydocs/core/feat/document/overview/domain/entity/school_info.dart';

class DocumentOverview extends Equatable {
  final String id;
  final String title;
  final SchoolInfo schoolInfo;
  final CourseInfo courseInfo;
  final bool isSaved;

  const DocumentOverview({
    required this.id,
    required this.title,
    required this.schoolInfo,
    required this.courseInfo,
    required this.isSaved,
  });

  DocumentOverview copyWith({
    String? id,
    String? title,
    SchoolInfo? schoolInfo,
    CourseInfo? courseInfo,
    bool? isSaved,
  }) {
    return DocumentOverview(
      id: id ?? this.id,
      title: title ?? this.title,
      schoolInfo: schoolInfo ?? this.schoolInfo,
      courseInfo: courseInfo ?? this.courseInfo,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [id, title, schoolInfo, courseInfo, isSaved];
}
