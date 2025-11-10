import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/home_remote_datasource.dart';
import 'package:studydocs/features/home/domain/repository/impl/home_repository_impl.dart';
import 'package:studydocs/features/home/domain/entity/document_entity.dart';
import 'package:studydocs/features/home/domain/usecase/get_documents_usecase.dart';

// Events
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

// States
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
  final String? searchQuery;

  const HomeLoaded({
    required this.documents,
    required this.popularDocuments,
    required this.recentDocuments,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
        documents,
        popularDocuments,
        recentDocuments,
        searchQuery,
      ];

  HomeLoaded copyWith({
    List<DocumentEntity>? documents,
    List<DocumentEntity>? popularDocuments,
    List<DocumentEntity>? recentDocuments,
    String? searchQuery,
  }) {
    return HomeLoaded(
      documents: documents ?? this.documents,
      popularDocuments: popularDocuments ?? this.popularDocuments,
      recentDocuments: recentDocuments ?? this.recentDocuments,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetDocumentsUseCase getDocumentsUseCase;
  final GetPopularDocumentsUseCase getPopularDocumentsUseCase;
  final GetRecentDocumentsUseCase getRecentDocumentsUseCase;
  final SearchDocumentsUseCase searchDocumentsUseCase;

  HomeBloc({
    required this.getDocumentsUseCase,
    required this.getPopularDocumentsUseCase,
    required this.getRecentDocumentsUseCase,
    required this.searchDocumentsUseCase,
  }) : super(const HomeInitial()) {
    on<LoadDocumentsEvent>(_onLoadDocuments);
    on<LoadPopularDocumentsEvent>(_onLoadPopularDocuments);
    on<LoadRecentDocumentsEvent>(_onLoadRecentDocuments);
    on<SearchDocumentsEvent>(_onSearchDocuments);
    on<RefreshDocumentsEvent>(_onRefreshDocuments);
  }

  Future<void> _onLoadDocuments(
    LoadDocumentsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      final documents = await getDocumentsUseCase();
      final popularDocuments = await getPopularDocumentsUseCase();
      final recentDocuments = await getRecentDocumentsUseCase();

      emit(HomeLoaded(
        documents: documents,
        popularDocuments: popularDocuments,
        recentDocuments: recentDocuments,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onLoadPopularDocuments(
    LoadPopularDocumentsEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      try {
        final popularDocuments = await getPopularDocumentsUseCase();
        emit((state as HomeLoaded).copyWith(
          popularDocuments: popularDocuments,
        ));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    }
  }

  Future<void> _onLoadRecentDocuments(
    LoadRecentDocumentsEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      try {
        final recentDocuments = await getRecentDocumentsUseCase();
        emit((state as HomeLoaded).copyWith(
          recentDocuments: recentDocuments,
        ));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    }
  }

  Future<void> _onSearchDocuments(
    SearchDocumentsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      final searchResults = await searchDocumentsUseCase(event.query);
      final popularDocuments = await getPopularDocumentsUseCase();
      final recentDocuments = await getRecentDocumentsUseCase();

      emit(HomeLoaded(
        documents: searchResults,
        popularDocuments: popularDocuments,
        recentDocuments: recentDocuments,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshDocuments(
    RefreshDocumentsEvent event,
    Emitter<HomeState> emit,
  ) async {
    add(const LoadDocumentsEvent());
  }
}

HomeBloc createHomeBloc() {
  // Khởi tạo DioClient
  final dioClient = DioClient();

  // Data layer
  final remoteDataSource = HomeRemoteDataSourceImpl(
    dioClient: dioClient,
  );

  final repository = HomeRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );

  // Domain layer - UseCases
  final getDocumentsUseCase = GetDocumentsUseCase(
    repository: repository,
  );
  final getPopularDocumentsUseCase = GetPopularDocumentsUseCase(
    repository: repository,
  );
  final getRecentDocumentsUseCase = GetRecentDocumentsUseCase(
    repository: repository,
  );
  final searchDocumentsUseCase = SearchDocumentsUseCase(
    repository: repository,
  );

  return HomeBloc(
    getDocumentsUseCase: getDocumentsUseCase,
    getPopularDocumentsUseCase: getPopularDocumentsUseCase,
    getRecentDocumentsUseCase: getRecentDocumentsUseCase,
    searchDocumentsUseCase: searchDocumentsUseCase,
  );
}

