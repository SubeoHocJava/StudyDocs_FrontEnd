import 'package:studydocs/core/widgets/feat/document/information/domain/entity/document_info.dart';
import 'package:studydocs/core/widgets/feat/document/overview/domain/entity/document_overview.dart';

import 'author.dart';
import 'course.dart';
import 'school.dart';

class Document {
  final String id;
  final String title;

  final School school;
  final Course course;

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

  DocumentOverview mapToOverview() {
    return DocumentOverview(
      id: id,
      title: title,
      schoolInfo: school.mapToOverview(),
      courseInfo: course.mapToOverview(),
      isSaved: isSaved,
    );
  }

  DocumentInfo mapToInformation() {
    return DocumentInfo(
      id: id,
      startYear: startYear,
      endYear: endYear,
      pageNumber: pageNumber,
      author: author.mapToInformation(),
      likeCount: likeCount,
      dislikeCount: dislikeCount,
      isLiked: isLiked,
      isDisliked: isDisliked,
    );
  }
}
