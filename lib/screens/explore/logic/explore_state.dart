import '../domain/entity/explore_model.dart';

abstract class ExploreState {}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final ExploreModel data;

  ExploreLoaded(this.data);
}

class ExploreError extends ExploreState {
  final String message;

  ExploreError(this.message);
}
