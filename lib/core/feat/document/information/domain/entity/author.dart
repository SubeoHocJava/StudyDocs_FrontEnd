
import 'package:studydocs/core/feat/document/information/domain/entity/school.dart';

class Author {
  final String id;
  final String avatarUrl;
  final String fullName;
  final School schoolInfo;

  Author({required this.id, required this.avatarUrl, required this.fullName, required this.schoolInfo});

}