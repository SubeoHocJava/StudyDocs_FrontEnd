import 'package:equatable/equatable.dart';
import 'package:studydocs/core/feat/document/information/domain/entity/document_info.dart';

abstract class DocumentInformationEvent extends Equatable {
  const DocumentInformationEvent();

  @override
  List<Object> get props => [];
}

class DocumentInformationDataReceived extends DocumentInformationEvent {
  final DocumentInfo documentInfo;

  const DocumentInformationDataReceived(this.documentInfo);

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

class SchoolClick extends DocumentInformationEvent {
  final String schoolId;

  const SchoolClick(this.schoolId);
  @override
  List<Object> get props => [schoolId];
}