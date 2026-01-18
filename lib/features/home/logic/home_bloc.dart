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
      
      // Find the latest version of the document in the current state to ensure valid toggle
      // We check all lists (documents, popular, recent)
      // Note: A doc might appear in multiple lists. We need to find consistent state or just use the first found?
      // Or simply, we iterate and update, and while iterating we determine the NEW state based on the CURRENT state of that item.
      
      bool? newIsLikedState; // To store the determined new state to use for API call

      // Helper to update a list AND capture the new state
      List<DocumentEntity> updateList(List<DocumentEntity> list) {
        return list.map((e) {
          if (e.id == doc.id) {
             final currentIsLiked = e.isLiked;
             final nextIsLiked = !currentIsLiked;
             
             // Capture this for the API call (only once is enough)
             if (newIsLikedState == null) {
                newIsLikedState = nextIsLiked;
             }

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
      
      // If we found the doc and updated it, newIsLikedState will be set.
      // If not (rare race condition or list changed), fallback to event.doc (but risky) or abort.
      final finalIsLiked = newIsLikedState ?? !doc.isLiked;

      emit(currentState.copyWith(
        documents: newDocuments,
        popularDocuments: newPopular,
        recentDocuments: newRecent,
      ));
      
      try {
        await toggleLikeUseCase(documentId: doc.id, reactionType: 'LIKE');
      } catch (e) {
         if (kDebugMode) print("Toggle like failed: $e");
         // Ideally revert here
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
