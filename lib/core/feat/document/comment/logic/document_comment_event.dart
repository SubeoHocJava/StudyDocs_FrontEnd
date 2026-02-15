
import 'package:equatable/equatable.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/comment.dart';

abstract class DocumentCommentEvent extends Equatable {
  const DocumentCommentEvent();

  @override
  List<Object?> get props => [];
}

class CommentRequested extends DocumentCommentEvent {
  final String content;
  final String documentId;

  const CommentRequested(this.content, this.documentId);

  @override
  List<Object?> get props => [content, documentId];
}

class ReceivedData extends DocumentCommentEvent {
  final List<Comment> comments;

  const ReceivedData(this.comments);

  @override
  List<Object?> get props => [comments];
}
class AuthorClick extends DocumentCommentEvent {
  final String authorId;

  const AuthorClick(this.authorId);
}
