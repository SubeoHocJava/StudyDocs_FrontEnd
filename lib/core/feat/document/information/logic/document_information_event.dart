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

class DocumentInformationLikeRequested extends DocumentInformationEvent {
  final String documentId;

  const DocumentInformationLikeRequested(this.documentId);

  @override
  List<Object> get props => [documentId];
}

class DocumentInformationDislikeRequested extends DocumentInformationEvent {
  final String documentId;

  const DocumentInformationDislikeRequested(this.documentId);

  @override
  List<Object> get props => [documentId];
}
