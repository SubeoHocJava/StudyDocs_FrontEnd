import 'package:equatable/equatable.dart';

import '../../docs/domain/entity/document_entity.dart';

abstract class DocsManagementState extends Equatable {
  const DocsManagementState();

  @override
  List<Object?> get props => [];
}

class DocsManagementInitial extends DocsManagementState {}

class DocsManagementLoading extends DocsManagementState {}

class DocsManagementLoaded extends DocsManagementState {
  final List<DocumentEntity> docs;
  final String? lastDeletedId; // To show Undo Snackbar if needed

  const DocsManagementLoaded(this.docs, {this.lastDeletedId});

  @override
  List<Object?> get props => [docs, lastDeletedId];
}

class DocsManagementDetailLoaded extends DocsManagementState {
  final DocumentEntity document;
  const DocsManagementDetailLoaded(this.document);
  @override
  List<Object?> get props => [document];
}

class DocsManagementError extends DocsManagementState {
  final String message;

  const DocsManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
