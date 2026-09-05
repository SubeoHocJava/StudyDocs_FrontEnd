import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';
import '../entity/explore_model.dart';

abstract interface class ExploreRepository {
  Future<ExploreModel> getExploreData();
  Future<List<DocumentSummaryModel>> searchDocuments(String query);
}
