import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

/// State cho 1 card: doc + thông báo lỗi (để hiển thị SnackBar rồi clear).
class DocsCardItemState {
  final DocumentSummaryModel doc;
  final String? lastError;

  const DocsCardItemState({required this.doc, this.lastError});

  DocsCardItemState copyWith({DocumentSummaryModel? doc, String? lastError}) {
    return DocsCardItemState(
      doc: doc ?? this.doc,
      lastError: lastError,
    );
  }
}
