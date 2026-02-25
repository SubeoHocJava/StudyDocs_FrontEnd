import 'package:equatable/equatable.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/author.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/content.dart';

class Comment extends Equatable{
  final String id;
  final String documentId;
  final List<ContentBlock> contents;
  final Author author;
  final DateTime createdAt;
  final int likeCount;
  final bool isLiked;
  final bool isMine;
  final String? replyToCommentId;

  const Comment({
    required this.id,
    required this.contents,
    required this.author,
    required this.createdAt,
    required this.documentId,
    this.likeCount = 0,
    this.isLiked = false,
    this.isMine = false,
    this.replyToCommentId,
  });

  Comment copyWith({
    String? id,
    String? documentId,
    List<ContentBlock>? contents,
    Author? author,
    DateTime? createdAt,
    int? likeCount,
    bool? isLiked,
    bool? isMine,
    String? replyToCommentId,
  }) {
    return Comment(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      contents: contents ?? this.contents,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isMine: isMine ?? this.isMine,
      replyToCommentId: replyToCommentId ?? this.replyToCommentId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    documentId,
    contents,
    author,
    createdAt,
    likeCount,
    isLiked,
    isMine,
    replyToCommentId,
  ];
}

