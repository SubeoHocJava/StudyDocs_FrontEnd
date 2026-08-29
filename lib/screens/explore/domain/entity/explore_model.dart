import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

class ExploreModel {
  final String universityName;
  final String hintText;
  final List<DocumentSummaryModel> mostLikedDocuments;
  final List<DocumentSummaryModel> newestDocuments;

  const ExploreModel({
    required this.universityName,
    required this.hintText,
    this.mostLikedDocuments = const [],
    this.newestDocuments = const [],
  });
}
