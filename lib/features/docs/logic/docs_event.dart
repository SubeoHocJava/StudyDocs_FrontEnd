import 'package:equatable/equatable.dart';

abstract class DocsEvent extends Equatable {
  const DocsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocDetails extends DocsEvent {}

class ToggleSave extends DocsEvent {}

class ToggleDocumentLike extends DocsEvent {
  final bool isLike; // true = like, false = dislike

  const ToggleDocumentLike(this.isLike);

  @override
  List<Object?> get props => [isLike];
}