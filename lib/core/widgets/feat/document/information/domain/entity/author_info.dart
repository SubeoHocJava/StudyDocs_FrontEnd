import 'package:studydocs/core/widgets/feat/document/information/domain/entity/school_info.dart';

class AuthorInfo {
  final String id;
  final String avatarUrl;
  final String fullName;
  final SchoolInfo school;

  AuthorInfo({required this.id, required this.avatarUrl, required this.fullName, required this.school});

}