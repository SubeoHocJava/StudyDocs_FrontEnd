import 'package:studydocs/core/widgets/feat/document/information/domain/entity/school.dart';

class Author {
  final String id;
  final String avatarUrl;
  final String fullName;
  final School school;

  const Author({
    required this.id,
    required this.avatarUrl,
    required this.fullName,
    required this.school,
  });
}