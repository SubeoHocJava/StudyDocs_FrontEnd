abstract class ExploreEvent {}

class FetchExploreDataEvent extends ExploreEvent {}

class SearchExploreEvent extends ExploreEvent {
  final String query;
  SearchExploreEvent(this.query);
}
