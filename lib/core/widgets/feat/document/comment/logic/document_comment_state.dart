
import 'package:equatable/equatable.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/comment.dart';

abstract class DocumentCommentState extends Equatable {
  const DocumentCommentState();

  @override
  List<Object?> get props => [];
}

class DocumentCommentInitial extends DocumentCommentState {}

class DocumentCommentLoaded extends DocumentCommentState {
  final List<Comment> comments;

  const DocumentCommentLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}
