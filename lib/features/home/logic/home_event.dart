import 'package:equatable/equatable.dart';
import 'package:studydocs/features/home/domain/entity/document_entity.dart';
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocumentsEvent extends HomeEvent {
  const LoadDocumentsEvent();
}

class LoadPopularDocumentsEvent extends HomeEvent {
  const LoadPopularDocumentsEvent();
}

class LoadRecentDocumentsEvent extends HomeEvent {
  const LoadRecentDocumentsEvent();
}

class SearchDocumentsEvent extends HomeEvent {
  final String query;

  const SearchDocumentsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshDocumentsEvent extends HomeEvent {
  const RefreshDocumentsEvent();
}

class UpdateSearchQueryEvent extends HomeEvent {
  final String query;
  const UpdateSearchQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class VoiceListeningChangedEvent extends HomeEvent {
  final bool isListening;
  const VoiceListeningChangedEvent(this.isListening);

  @override
  List<Object?> get props => [isListening];
}



class ToggleHomeLikeEvent extends HomeEvent {
  final DocumentEntity document;
  const ToggleHomeLikeEvent(this.document);

  @override
  List<Object?> get props => [document];
}
