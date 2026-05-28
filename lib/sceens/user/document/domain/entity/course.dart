import 'package:studydocs/core/widgets/feat/document/overview/domain/entity/course_info.dart';

class Course {
  final String id;
  final String name;

  const Course({required this.id, required this.name});

  CourseInfo mapToOverview() {
    return CourseInfo(id: id, name: name);
  }
}
