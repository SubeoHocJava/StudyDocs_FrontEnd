import 'package:equatable/equatable.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

class HomeDocumentsPage extends Equatable {
  final List<DocumentSummaryModel> items;
  final int page;
  final int pageSize;
  final int total;
  final bool hasMore;

  const HomeDocumentsPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [items, page, pageSize, total, hasMore];
}
