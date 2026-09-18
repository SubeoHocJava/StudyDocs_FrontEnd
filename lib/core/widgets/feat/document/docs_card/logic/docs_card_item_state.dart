import 'package:equatable/equatable.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

class DocsCardItemState extends Equatable {
  final DocumentSummaryModel doc;
  final String? lastError;

  const DocsCardItemState({
    required this.doc,
    this.lastError,
  });

  DocsCardItemState copyWith({
    DocumentSummaryModel? doc,
    String? lastError,
  }) {
    return DocsCardItemState(
      doc: doc ?? this.doc,
      lastError: lastError,
    );
  }

  @override
  List<Object?> get props => [doc, lastError];
}
