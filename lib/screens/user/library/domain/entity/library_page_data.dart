import 'package:equatable/equatable.dart';
import 'package:studydocs/core/widgets/feat/common/folder_list/domain/entity/folder_item.dart';
import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

class LibraryPageData extends Equatable {
  final List<FolderItem> subjects;
  final List<DocumentCompactModel> recentDocuments;
  final List<DocumentSummaryModel> savedDocuments;

  const LibraryPageData({
    required this.subjects,
    required this.recentDocuments,
    required this.savedDocuments,
  });

  @override
  List<Object?> get props => [subjects, recentDocuments, savedDocuments];
}
