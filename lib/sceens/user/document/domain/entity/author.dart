import 'package:studydocs/core/widgets/feat/document/information/domain/entity/author_info.dart';
import 'package:studydocs/core/widgets/feat/document/information/domain/entity/school_info.dart';

class Author {
  final String id;
  final String avatarUrl;
  final String fullName;
  final SchoolInfo school;

  const Author({
    required this.id,
    required this.avatarUrl,
    required this.fullName,
    required this.school,
  });

  AuthorInfo mapToInformation() {
    return AuthorInfo(
      id: id,
      avatarUrl: avatarUrl,
      fullName: fullName,
      school: school,
    );
  }
}
