import 'author.dart';
import 'course_info.dart';
import 'school.dart';

class Document {
  final String id;
  final String title;

  final School school;
  final CourseInfo course;

  final int startYear;
  final int endYear;
  final int pageNumber;

  final int likeCount;
  final int dislikeCount;

  final bool isLiked;
  final bool isDisliked;
  final bool isSaved;

  final Author author;

  const Document({
    required this.id,
    required this.title,
    required this.school,
    required this.course,
    required this.startYear,
    required this.endYear,
    required this.pageNumber,
    required this.likeCount,
    required this.dislikeCount,
    required this.isLiked,
    required this.isDisliked,
    required this.isSaved,
    required this.author,
  });

  Document copyWith({
    String? id,
    String? title,
    School? school,
    CourseInfo? course,
    int? startYear,
    int? endYear,
    int? pageNumber,
    int? likeCount,
    int? dislikeCount,
    bool? isLiked,
    bool? isDisliked,
    bool? isSaved,
    Author? author,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      school: school ?? this.school,
      course: course ?? this.course,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      pageNumber: pageNumber ?? this.pageNumber,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      isSaved: isSaved ?? this.isSaved,
      author: author ?? this.author,
    );
  }
}