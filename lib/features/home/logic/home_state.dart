import 'package:equatable/equatable.dart';
import 'package:studydocs/features/home/domain/entity/document_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<DocumentEntity> documents;
  final List<DocumentEntity> popularDocuments;
  final List<DocumentEntity> recentDocuments;
  final String searchQuery;
  final bool isListening;

  const HomeLoaded({
    required this.documents,
    required this.popularDocuments,
    required this.recentDocuments,
    this.searchQuery = '',
    this.isListening = false,
  });

  List<DocumentEntity> get filteredDocuments {
    if (searchQuery.isEmpty) return documents;
    return documents
        .where((doc) =>
            doc.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (doc.author?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false))
        .toList();
  }

  @override
  List<Object?> get props => [
        documents,
        popularDocuments,
        recentDocuments,
        searchQuery,
        isListening,
      ];

  HomeLoaded copyWith({
    List<DocumentEntity>? documents,
    List<DocumentEntity>? popularDocuments,
    List<DocumentEntity>? recentDocuments,
    String? searchQuery,
    bool? isListening,
  }) {
    return HomeLoaded(
      documents: documents ?? this.documents,
      popularDocuments: popularDocuments ?? this.popularDocuments,
      recentDocuments: recentDocuments ?? this.recentDocuments,
      searchQuery: searchQuery ?? this.searchQuery,
      isListening: isListening ?? this.isListening,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
