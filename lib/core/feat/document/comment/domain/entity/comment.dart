import 'package:studydocs/core/feat/document/comment/domain/entity/author.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/content.dart';

class Comment {
  final String id;
  final String documentId;
  final List<ContentBlock> contents;
  final Author author;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.contents,
    required this.author,
    required this.createdAt,
    required this.documentId,
  });
}
