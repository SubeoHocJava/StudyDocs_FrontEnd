import 'package:equatable/equatable.dart';

abstract class DocumentDetailEvent extends Equatable {
  const DocumentDetailEvent();

  @override
  List<Object?> get props => [];
}

class DocumentDetailRequested extends DocumentDetailEvent {
  final String documentId;

  const DocumentDetailRequested(this.documentId);

  @override
  List<Object?> get props => [documentId];
}
