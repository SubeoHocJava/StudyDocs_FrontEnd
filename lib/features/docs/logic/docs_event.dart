import 'package:equatable/equatable.dart';

abstract class DocsEvent extends Equatable {
  const DocsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocDetails extends DocsEvent {
  const LoadDocDetails();
  @override
  List<Object?> get props => [];
}

class ToggleSave extends DocsEvent {}

class ToggleDocumentLike extends DocsEvent {
  final bool isLike; // true = like, false = dislike

  const ToggleDocumentLike({required this.isLike});

  @override
  List<Object?> get props => [isLike];
}

class PostComment extends DocsEvent {
  final String text;

  const PostComment(this.text);

  @override
  List<Object?> get props => [text];
}

class ReactToReview extends DocsEvent {
  final String reviewId;
  final bool isLike;

  const ReactToReview({required this.reviewId, required this.isLike});

  @override
  List<Object?> get props => [reviewId, isLike];
}

class DeleteDocument extends DocsEvent {
  const DeleteDocument();
  @override
  List<Object?> get props => [];
}

class UpdateDocument extends DocsEvent {
  final String title;
  final String description;
  final String year;

  const UpdateDocument({
    required this.title,
    required this.description,
    required this.year,
  });

  @override
  List<Object?> get props => [title, description, year];
}

