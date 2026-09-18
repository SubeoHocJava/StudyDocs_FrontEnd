
import 'package:equatable/equatable.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/comment.dart';

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

class LoadCommentsRequested extends DocumentCommentEvent {
  final String documentId;

  const LoadCommentsRequested(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class LoadCommentRepliesRequested extends DocumentCommentEvent {
  final String documentId;
  final String commentId;

  const LoadCommentRepliesRequested(this.documentId, this.commentId);

  @override
  List<Object?> get props => [documentId, commentId];
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

class CommentReplied extends DocumentCommentEvent {
  final String documentId;
  final String commentId;
  final String content;

  const CommentReplied(this.documentId, this.commentId, this.content);

  @override
  List<Object?> get props => [documentId, commentId, content];
}

class CommentLiked extends DocumentCommentEvent {
  final String documentId;
  final String commentId;

  const CommentLiked(this.documentId, this.commentId);

  @override
  List<Object?> get props => [documentId, commentId];
}

class CommentUnliked extends DocumentCommentEvent {
  final String documentId;
  final String commentId;

  const CommentUnliked(this.documentId, this.commentId);

  @override
  List<Object?> get props => [documentId, commentId];
}

class CommentEdited extends DocumentCommentEvent {
  final String documentId;
  final String commentId;
  final String content;

  const CommentEdited(this.documentId, this.commentId, this.content);

  @override
  List<Object?> get props => [documentId, commentId, content];
}

class CommentDeleted extends DocumentCommentEvent {
  final String documentId;
  final String commentId;

  const CommentDeleted(this.documentId, this.commentId);

  @override
  List<Object?> get props => [documentId, commentId];
}
