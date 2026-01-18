import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/impl/academic_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/docs_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/asset_remote_datasource_impl.dart'; //  Import Asset Impl
import 'package:studydocs/data/datasource/docs_remote_datasource.dart'; // Import DocsRemoteDataSourceImpl
import 'package:studydocs/data/datasource/impl/document_remote_datasource_impl.dart';
import 'package:studydocs/features/home/domain/entity/document_entity.dart';
import 'package:studydocs/features/home/domain/repository/impl/home_repository_impl.dart';
import 'package:studydocs/features/home/domain/usecase/get_documents_usecase.dart';
import 'package:studydocs/features/home/logic/home_event.dart';
import 'package:studydocs/features/home/logic/home_state.dart';
import 'package:studydocs/features/docs/domain/usecase/toggle_like_usecase.dart';
import 'package:studydocs/features/docs/domain/repository/docs_repository.dart'; // Needed for type but impl handles it
import 'package:studydocs/features/docs/data/repository/docs_repository_impl.dart'; // Needed for DI
import 'package:studydocs/features/docs/domain/usecase/get_document_usecase.dart'; // Standard imports
import 'package:studydocs/features/docs/domain/usecase/toggle_save_usecase.dart';
import 'package:studydocs/features/docs/domain/usecase/post_comment_usecase.dart';
import 'package:studydocs/features/docs/domain/usecase/react_review_usecase.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetDocumentsUseCase getDocumentsUseCase;
  final GetPopularDocumentsUseCase getPopularDocumentsUseCase;
  final GetRecentDocumentsUseCase getRecentDocumentsUseCase;
  final SearchDocumentsUseCase searchDocumentsUseCase;
  final ToggleLikeUseCase toggleLikeUseCase;

  HomeBloc({
    required this.getDocumentsUseCase,
    required this.getPopularDocumentsUseCase,
    required this.getRecentDocumentsUseCase,
    required this.searchDocumentsUseCase,
    required this.toggleLikeUseCase,
  }) : super(const HomeInitial()) {
    on<LoadDocumentsEvent>(_onLoadDocuments);
    on<UpdateSearchQueryEvent>(_onUpdateSearchQuery);
    on<VoiceListeningChangedEvent>(_onVoiceListeningChanged);
    on<RefreshDocumentsEvent>(_onRefreshDocuments);
    on<SearchDocumentsEvent>(_onSearchDocuments);
    on<ToggleHomeLikeEvent>(_onToggleLike);
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

    try {
      documents = await getDocumentsUseCase();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load documents: $e');
      }
      // Keep empty list - UI sẽ hiển thị empty state
    }

    try {
      popularDocuments = await getPopularDocumentsUseCase();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load popular documents: $e');
      }
      // Keep empty list
    }

    try {
      recentDocuments = await getRecentDocumentsUseCase();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load recent documents: $e');
      }
      // Keep empty list
    }

    // Emit state với data có sẵn (có thể 1 số section empty)
    emit(
      HomeLoaded(
        documents: documents,
        popularDocuments: popularDocuments,
        recentDocuments: recentDocuments,
      ),
    );
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
    final isLike = !doc.isLiked;
        
    // Optimistic Update
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      
      // Helper to update a list
      List<DocumentEntity> updateList(List<DocumentEntity> list) {
        return list.map((e) {
          if (e.id == doc.id) {
             final newLikes = isLike 
                 ? (e.likesCount ?? 0) + 1 
                 : (e.likesCount ?? 1) - 1;
             return e.copyWith(
               isLiked: isLike,
               likesCount: newLikes >= 0 ? newLikes : 0,
             );
          }
          return e;
        }).toList();
      }

      emit(currentState.copyWith(
        documents: updateList(currentState.documents),
        popularDocuments: updateList(currentState.popularDocuments),
        recentDocuments: updateList(currentState.recentDocuments),
      ));
    }

    try {
      await toggleLikeUseCase(documentId: doc.id, isLike: isLike);
    } catch (e) {
      // Revert if failed (optional, but good practice)
       if (state is HomeLoaded) {
           // For simplicity, just reload or revert manually. 
           // Given optimistic update complexity, we might skip full revert logic 
           // or just trigger specific reload.
           // For now, let's just log.
           if (kDebugMode) print("Toggle like failed: $e");
       }
    }
  }
}

HomeBloc createHomeBloc() {
  final dioClient = DioClient();
  final remoteDataSource = DocumentRemoteDataSourceImpl(dioClient: dioClient);
  final academicDataSource = AcademicRemoteDataSourceImpl(dioClient: dioClient);
  final assetDataSource = AssetRemoteDataSourceImpl(
    dioClient: dioClient,
  ); // ✅ Create Asset DataSource
  final docsRemoteDataSource = DocsRemoteDataSourceImpl(dioClient: dioClient);

  final repository = HomeRepositoryImpl(
    remoteDataSource: remoteDataSource,
    academicDataSource: academicDataSource,
    assetDataSource: assetDataSource, // ✅ Inject Asset DataSource
    docsRemoteDataSource: docsRemoteDataSource, // ✅ Inject Docs DataSource
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
  );
}
