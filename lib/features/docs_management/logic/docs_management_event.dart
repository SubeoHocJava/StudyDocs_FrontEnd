import 'package:equatable/equatable.dart';

import '../../docs/domain/entity/document_entity.dart';

abstract class DocsManagementEvent extends Equatable {
  const DocsManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyDocs extends DocsManagementEvent {
  final String? filterSchool;
  final String? filterSubject;
  final String? filterYear;

  const LoadMyDocs({this.filterSchool, this.filterSubject, this.filterYear});

  @override
  List<Object?> get props => [filterSchool, filterSubject, filterYear];
}

class DeleteDocEvent extends DocsManagementEvent {
  final String docId;

  const DeleteDocEvent(this.docId);

  @override
  List<Object?> get props => [docId];
}

class UpdateDocEvent extends DocsManagementEvent {
  final String docId;
  final DocumentEntity updatedDoc;

  const UpdateDocEvent(this.docId, this.updatedDoc);

  @override
  List<Object?> get props => [docId, updatedDoc];
}

class UploadDocEvent extends DocsManagementEvent {
  final dynamic file; // File from dart:io
  final DocumentEntity metadata;

  const UploadDocEvent(this.file, this.metadata);

  @override
  List<Object?> get props => [file, metadata];
}
