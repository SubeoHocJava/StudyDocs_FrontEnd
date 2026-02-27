import 'package:equatable/equatable.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/comment.dart';

class CommentNode extends Equatable {
  final Comment comment;
  final List<CommentNode> children;

  const CommentNode({
    required this.comment,
    this.children = const [],
  });

  @override
  List<Object?> get props => [comment, children];
}
