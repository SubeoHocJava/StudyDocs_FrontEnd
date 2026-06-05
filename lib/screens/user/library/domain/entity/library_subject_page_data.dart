import 'package:equatable/equatable.dart';
import 'package:studydocs/data/model/document_model/response/document_compact_model.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

class LibrarySubjectPageData extends Equatable {
  final String subjectId;
  final String schoolName;
  final String subjectName;
  final int userCount;
  final List<DocumentCompactModel> uploadedDocuments;
  final List<DocumentCompactModel> topLikedDocuments;
  final List<DocumentSummaryModel> storedDocuments;

  const LibrarySubjectPageData({
    required this.subjectId,
    required this.schoolName,
    required this.subjectName,
    required this.userCount,
    required this.uploadedDocuments,
    required this.topLikedDocuments,
    required this.storedDocuments,
  });

  int get documentCount =>
      uploadedDocuments.length + topLikedDocuments.length + storedDocuments.length;

  @override
  List<Object?> get props => [
        subjectId,
        schoolName,
        subjectName,
        userCount,
        uploadedDocuments,
        topLikedDocuments,
        storedDocuments,
      ];
}
