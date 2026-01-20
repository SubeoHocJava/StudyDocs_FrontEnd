import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/impl/academic_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/docs_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/asset_remote_datasource_impl.dart'; //  Import Asset Impl
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';
import 'package:studydocs/features/home/domain/entity/document_entity.dart';
import 'package:studydocs/features/home/domain/repository/impl/home_repository_impl.dart';
import 'package:studydocs/features/home/domain/usecase/get_documents_usecase.dart';
import 'package:studydocs/features/home/logic/home_event.dart';
import 'package:studydocs/features/home/logic/home_state.dart';
import 'package:studydocs/features/docs/domain/usecase/toggle_like_usecase.dart';
import 'package:studydocs/features/docs/data/repository/docs_repository_impl.dart'; // Needed for DI
import 'package:studydocs/features/docs/domain/usecase/toggle_save_usecase.dart';
import 'package:studydocs/core/error/error_mapper.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetDocumentsUseCase getDocumentsUseCase;
  final GetPopularDocumentsUseCase getPopularDocumentsUseCase;
  final GetRecentDocumentsUseCase getRecentDocumentsUseCase;
  final SearchDocumentsUseCase searchDocumentsUseCase;
  final ToggleLikeUseCase toggleLikeUseCase;
  final ToggleSaveUseCase toggleSaveUseCase;

  HomeBloc({
    required this.getDocumentsUseCase,
    required this.getPopularDocumentsUseCase,
    required this.getRecentDocumentsUseCase,
    required this.searchDocumentsUseCase,
    required this.toggleLikeUseCase,
    required this.toggleSaveUseCase,
  }) : super(const HomeInitial()) {
    on<LoadDocumentsEvent>(_onLoadDocuments);
    on<UpdateSearchQueryEvent>(_onUpdateSearchQuery);
    on<VoiceListeningChangedEvent>(_onVoiceListeningChanged);
    on<RefreshDocumentsEvent>(_onRefreshDocuments);
    on<SearchDocumentsEvent>(_onSearchDocuments);
    on<ToggleHomeLikeEvent>(_onToggleLike);
    on<ToggleHomeSaveEvent>(_onToggleSave);
  }

  Future<void> _onLoadDocuments(
    LoadDocumentsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    // Fetch từng section independently - nếu 1 section fail, các section khác vẫn OK
    List<DocumentEntity> documents = [];
    List<DocumentEntity> popularDocuments = [];
    List<DocumentEntity> recentDocuments = [];

    // Use a flag to track if at least one section loaded successfully
    bool hasData = false;
    String? combinedError;

    try {
      documents = await getDocumentsUseCase();
      hasData = true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load documents: $e');
      }
      combinedError = _getErrorMessage(e);
    }

    try {
      popularDocuments = await getPopularDocumentsUseCase();
      hasData = true;
    } catch (e) {
       if (kDebugMode) {
        print('Failed to load popular documents: $e');
      }
      combinedError = _getErrorMessage(e);
    }

    try {
      recentDocuments = await getRecentDocumentsUseCase();
      hasData = true;
    } catch (e) {
       if (kDebugMode) {
        print('Failed to load recent documents: $e');
      }
      combinedError = _getErrorMessage(e);
    }

    // If at least one section has data, we show what we have.
    if (hasData) {
      emit(
        HomeLoaded(
          documents: documents,
          popularDocuments: popularDocuments,
          recentDocuments: recentDocuments,
        ),
      );
    } else {
      emit(HomeError(combinedError ?? ErrorMapper.map(500)));
    }
  }

  void _onUpdateSearchQuery(
    UpdateSearchQueryEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(searchQuery: event.query));
    }
  }

  void _onVoiceListeningChanged(
    VoiceListeningChangedEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(isListening: event.isListening));
    }
  }

  Future<void> _onToggleSave(
    ToggleHomeSaveEvent event,
    Emitter<HomeState> emit,
  ) async {
    final doc = event.document;
    
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      
      // Store original lists for revert
      final originalDocuments = currentState.documents;
      final originalPopular = currentState.popularDocuments;
      final originalRecent = currentState.recentDocuments;

      bool? newIsSavedState;

      List<DocumentEntity> updateList(List<DocumentEntity> list) {
        return list.map((e) {
          if (e.id == doc.id) {
             final nextIsSaved = !e.isSaved;
             if (newIsSavedState == null) newIsSavedState = nextIsSaved;
             return e.copyWith(isSaved: nextIsSaved);
          }
          return e;
        }).toList();
      }

      final newDocuments = updateList(currentState.documents);
      final newPopular = updateList(currentState.popularDocuments);
      final newRecent = updateList(currentState.recentDocuments);

      emit(currentState.copyWith(
        documents: newDocuments,
        popularDocuments: newPopular,
        recentDocuments: newRecent,
        actionError: null,
      ));
      
      try {
        await toggleSaveUseCase(documentId: doc.id);
      } catch (e) {
         if (kDebugMode) print("Toggle save failed: $e");
         
         emit(currentState.copyWith(
           documents: originalDocuments,
           popularDocuments: originalPopular,
           recentDocuments: originalRecent,
           actionError: _getErrorMessage(e),
         ));
      }
    }
  }

  Future<void> _onSearchDocuments(
    SearchDocumentsEvent event,
    Emitter<HomeState> emit,
  ) async {
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

  Future<void> _onToggleLike(
    ToggleHomeLikeEvent event,
    Emitter<HomeState> emit,
  ) async {
    final doc = event.document;
    
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      // Store original for revert
      final originalDocuments = currentState.documents;
      final originalPopular = currentState.popularDocuments;
      final originalRecent = currentState.recentDocuments;
      
      bool? newIsLikedState;

      List<DocumentEntity> updateList(List<DocumentEntity> list) {
        return list.map((e) {
          if (e.id == doc.id) {
             final currentIsLiked = e.isLiked;
             final nextIsLiked = !currentIsLiked;
             if (newIsLikedState == null) newIsLikedState = nextIsLiked;

             final newLikes = nextIsLiked 
                 ? (e.likesCount ?? 0) + 1 
                 : (e.likesCount ?? 1) - 1;
             
             return e.copyWith(
               isLiked: nextIsLiked,
               likesCount: newLikes >= 0 ? newLikes : 0,
             );
          }
          return e;
        }).toList();
      }

      final newDocuments = updateList(currentState.documents);
      final newPopular = updateList(currentState.popularDocuments);
      final newRecent = updateList(currentState.recentDocuments);

      emit(currentState.copyWith(
        documents: newDocuments,
        popularDocuments: newPopular,
        recentDocuments: newRecent,
        actionError: null,
      ));
      
      try {
        await toggleLikeUseCase(documentId: doc.id, reactionType: 'LIKE');
      } catch (e) {
         if (kDebugMode) print("Toggle like failed: $e");
         
         // Revert state and set error
         emit(currentState.copyWith(
            documents: originalDocuments,
            popularDocuments: originalPopular,
            recentDocuments: originalRecent,
            actionError: _getErrorMessage(e),
         ));
      }
    } else {
       // Backup if state is not Loaded (unlikely for click)
       try {
        await toggleLikeUseCase(documentId: doc.id, reactionType: 'LIKE');
      } catch (e) {
         if (kDebugMode) print("Toggle like failed: $e");
      }
    }
  }

  String _getErrorMessage(Object error) {
    if (error is ApiException) {
      return ErrorMapper.map(int.tryParse(error.code ?? ''));
    }
    return ErrorMapper.map(500);
  }
}

HomeBloc createHomeBloc() {
  final dioClient = DioClient();
  final remoteDataSource = DocumentRemoteDataSourceImpl(dioClient: dioClient);
  final academicDataSource = AcademicRemoteDataSourceImpl(dioClient: dioClient);
  final assetDataSource = AssetRemoteDataSourceImpl(
    dioClient: dioClient,
  ); 
  final docsRemoteDataSource = DocsRemoteDataSourceImpl(dioClient: dioClient);

  final repository = HomeRepositoryImpl(
    remoteDataSource: remoteDataSource,
    academicDataSource: academicDataSource,
    assetDataSource: assetDataSource, 
    docsRemoteDataSource: docsRemoteDataSource, 
  );

  final docsRepository = DocsRepositoryImpl(
      dataSource: docsRemoteDataSource, 
  );

  return HomeBloc(
    getDocumentsUseCase: GetDocumentsUseCase(repository: repository),
    getPopularDocumentsUseCase: GetPopularDocumentsUseCase(
      repository: repository,
    ),
    getRecentDocumentsUseCase: GetRecentDocumentsUseCase(
      repository: repository,
    ),
    searchDocumentsUseCase: SearchDocumentsUseCase(repository: repository),
    toggleLikeUseCase: ToggleLikeUseCase(docsRepository),
    toggleSaveUseCase: ToggleSaveUseCase(docsRepository),
  );
}
