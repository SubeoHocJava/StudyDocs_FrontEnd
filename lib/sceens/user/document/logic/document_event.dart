import 'package:equatable/equatable.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

class GetDocumentRequested extends DocumentEvent {
  final String documentId;

  const GetDocumentRequested({required this.documentId});

  @override
  List<Object?> get props => [documentId];
}
