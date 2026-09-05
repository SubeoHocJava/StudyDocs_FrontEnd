import '../domain/entity/explore_model.dart';
import 'package:studydocs/data/model/document_model/response/document_summary_model.dart';

abstract class ExploreState {}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final ExploreModel data;
  ExploreLoaded(this.data);
}

class ExploreSearching extends ExploreState {}

class ExploreSearchResult extends ExploreState {
  final String query;
  final List<DocumentSummaryModel> results;
  ExploreSearchResult({required this.query, required this.results});
}

class ExploreError extends ExploreState {
  final String message;
  ExploreError(this.message);
}
