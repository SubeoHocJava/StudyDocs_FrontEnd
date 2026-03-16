import 'package:equatable/equatable.dart';
import 'package:studydocs/core/widgets/feat/document/information/domain/entity/document_info.dart';

abstract class DocumentInformationEvent extends Equatable {
  const DocumentInformationEvent();

  @override
  List<Object> get props => [];
}

class DocumentInformationDataReceived extends DocumentInformationEvent {
  final DocumentInfo documentInfo;

  const DocumentInformationDataReceived({required this.documentInfo});

  @override
  List<Object> get props => [documentInfo];
}

class DocumentLikeRequested extends DocumentInformationEvent {
  final String documentId;

  const DocumentLikeRequested(this.documentId);

  @override
  List<Object> get props => [documentId];
}

class DocumentDislikeRequested extends DocumentInformationEvent {
  final String documentId;

  const DocumentDislikeRequested(this.documentId);

  @override
  List<Object> get props => [documentId];
}

class AuthorClick extends DocumentInformationEvent {
  final String authorId;

  const AuthorClick(this.authorId);

  @override
  List<Object> get props => [authorId];
}
