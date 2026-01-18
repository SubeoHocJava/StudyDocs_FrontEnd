import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecase/load_document_usecase.dart';
import '../domain/usecase/search_document_usecase.dart';
import '../domain/usecase/download_document_usecase.dart';
import '../domain/usecase/save_document_usecase.dart';
import '../domain/usecase/like_document_usecase.dart';
import '../domain/usecase/get_saved_documents_usecase.dart';

import 'LibraryEvent.dart';
import 'LibraryState.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LoadDocumentUseCase loadDocumentUseCase;
  final SearchDocumentUseCase searchDocumentUseCase;
  final DownloadDocumentUseCase downloadDocumentUseCase;
  final SaveDocumentUseCase saveDocumentUseCase;
  final LikeDocumentUseCase likeDocumentUseCase;
  final GetSavedDocumentsUseCase getSavedDocumentsUseCase;


  LibraryBloc({
    required this.loadDocumentUseCase,
    required this.searchDocumentUseCase,
    required this.downloadDocumentUseCase,
    required this.saveDocumentUseCase,
    required this.likeDocumentUseCase,
    required this.getSavedDocumentsUseCase,
  }) : super(LibraryInitial()) {
    on<LoadDocumentByKeyWord>(_onLoadDocument);
    on<SearchDocument>(_onSearchDocument);
    on<DownloadDocumentRequested>(_onDownloadDocument);
    on<SaveDocumentRequested>(_onSaveDocument);
    on<LikeDocumentRequested>(_onLikeDocument);
    on<LoadSavedDocuments>(_onLoadSavedDocuments);
  }

  Future<void> _onLoadDocument(
      LoadDocumentByKeyWord event,
      Emitter<LibraryState> emit,
      ) async {
    emit(LibraryLoading());
    try {
      final result = await loadDocumentUseCase(event.keyword);
      List<String> cate=["Flutter","Backend","Mobile","Clean Architecture","DevOps"];
      emit(LibraryLoaded(
        documents: result,
        categories:cate
      ));
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  Future<void> _onSearchDocument(
      SearchDocument event,
      Emitter<LibraryState> emit,
      ) async {
    emit(LibraryLoading());
    try {
      final result = await searchDocumentUseCase(event.keyword);
      List<String> cate=["Flutter","Backend","Mobile","Clean Architecture","DevOps"];
      emit(LibraryLoaded(
        documents: result,
        categories: cate,
      ));
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  Future<void> _onDownloadDocument(
      DownloadDocumentRequested event,
      Emitter<LibraryState> emit,
      ) async {
    try {
      await downloadDocumentUseCase(event.documentId);
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  Future<void> _onSaveDocument(
      SaveDocumentRequested event,
      Emitter<LibraryState> emit,
      ) async {
    try {
      await saveDocumentUseCase(event.documentId);

    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  Future<void> _onLikeDocument(
      LikeDocumentRequested event,
      Emitter<LibraryState> emit,
      ) async {
    try {
      await likeDocumentUseCase(event.documentId);
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  Future<void> _onLoadSavedDocuments(
      LoadSavedDocuments event,
      Emitter<LibraryState> emit,
      ) async {
    try {
      final savedDocs = await getSavedDocumentsUseCase();
      
      // Update the current state with saved documents
      if (state is LibraryLoaded) {
        emit((state as LibraryLoaded).copyWith(savedDocuments: savedDocs));
      } else {
        // If not loaded yet, emit a new loaded state with saved documents
        List<String> cate=["Flutter","Backend","Mobile","Clean Architecture","DevOps"];
        emit(LibraryLoaded(
          documents: const [],
          categories: cate,
          savedDocuments: savedDocs,
        ));
      }
    } catch (e) {
      print('Error loading saved documents: $e');
      // Don't emit error state, just log it
    }
  }
}
