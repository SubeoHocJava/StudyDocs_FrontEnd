import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/home_remote_datasource.dart';
import 'package:studydocs/features/home/domain/repository/impl/home_repository_impl.dart';
import 'package:studydocs/features/home/domain/usecase/get_documents_usecase.dart';
import 'package:studydocs/features/home/logic/home_event.dart';
import 'package:studydocs/features/home/logic/home_state.dart';

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
    on<UpdateSearchQueryEvent>(_onUpdateSearchQuery);
    on<VoiceListeningChangedEvent>(_onVoiceListeningChanged);
    on<RefreshDocumentsEvent>(_onRefreshDocuments);
    on<SearchDocumentsEvent>(_onSearchDocuments);
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

  void _onUpdateSearchQuery(UpdateSearchQueryEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(searchQuery: event.query));
    }
  }

  void _onVoiceListeningChanged(VoiceListeningChangedEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(isListening: event.isListening));
    }
  }

  Future<void> _onSearchDocuments(SearchDocumentsEvent event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(searchQuery: event.query));
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
  final dioClient = DioClient();
  final remoteDataSource = HomeRemoteDataSourceImpl(dioClient: dioClient);
  final repository = HomeRepositoryImpl(remoteDataSource: remoteDataSource);

  return HomeBloc(
    getDocumentsUseCase: GetDocumentsUseCase(repository: repository),
    getPopularDocumentsUseCase: GetPopularDocumentsUseCase(repository: repository),
    getRecentDocumentsUseCase: GetRecentDocumentsUseCase(repository: repository),
    searchDocumentsUseCase: SearchDocumentsUseCase(repository: repository),
  );
}

