import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/model/document_library.dart';
import '../domain/usecase/load_document_usecase.dart';
import '../domain/usecase/search_document_usecase.dart';
import '../domain/usecase/download_document_usecase.dart';
import '../domain/usecase/save_document_usecase.dart';
import '../domain/usecase/like_document_usecase.dart';
import '../domain/usecase/get_saved_documents_usecase.dart';
import '../../subject_library/domain/usecase/get_all_subjects_usecase.dart';
import '../../subject_library/domain/entity/subject_entity.dart';

import 'LibraryEvent.dart';
import 'LibraryState.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LoadDocumentUseCase loadDocumentUseCase;
  final SearchDocumentUseCase searchDocumentUseCase;
  final DownloadDocumentUseCase downloadDocumentUseCase;
  final SaveDocumentUseCase saveDocumentUseCase;
  final LikeDocumentUseCase likeDocumentUseCase;
  final GetSavedDocumentsUseCase getSavedDocumentsUseCase;
  final GetAllSubjectsUseCase getAllSubjectsUseCase;


  LibraryBloc({
    required this.loadDocumentUseCase,
    required this.searchDocumentUseCase,
    required this.downloadDocumentUseCase,
    required this.saveDocumentUseCase,
    required this.likeDocumentUseCase,
    required this.getSavedDocumentsUseCase,
    required this.getAllSubjectsUseCase,
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
    print('>>> LIBRARY_BLOC: _onLoadDocument started with keyword: ${event.keyword}');
    emit(LibraryLoading());
    try {
      final result = await loadDocumentUseCase(event.keyword);
      
      // Fetch subjects safely
      List<SubjectEntity> subjects = [];
      try {
        subjects = await getAllSubjectsUseCase();
      } catch (e) {
        print('Error loading subjects: $e');
        // Fallback or keep empty
      }
      
      // Fetch savedDocuments
      List<DocumentLibraryUI> savedDocs = [];
      try {
        savedDocs = await getSavedDocumentsUseCase();
      } catch (e) {
        print('Error loading saved docs: $e');
        // Fallback to existing if available
        if (state is LibraryLoaded) {
          savedDocs = (state as LibraryLoaded).savedDocuments;
        }
      }
      
      emit(LibraryLoaded(
        documents: result,
        categories: subjects,
        savedDocuments: savedDocs,
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
      
      List<SubjectEntity> subjects = [];
      List<DocumentLibraryUI> savedDocs = [];
      
      if (state is LibraryLoaded) {
        final loadedState = state as LibraryLoaded;
        subjects = loadedState.categories;
        savedDocs = loadedState.savedDocuments;
      } else {
         try {
           subjects = await getAllSubjectsUseCase();
         } catch (e) {
           print('Error loading subjects in search: $e');
         }
      }

      emit(LibraryLoaded(
        documents: result,
        categories: subjects,
        savedDocuments: savedDocs,
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
        List<SubjectEntity> subjects = [];
        try {
          subjects = await getAllSubjectsUseCase();
        } catch (e) {
          print('Error loading subjects in saved docs: $e');
        }

        emit(LibraryLoaded(
          documents: const [],
          categories: subjects,
          savedDocuments: savedDocs,
        ));
      }
    } catch (e) {
      print('Error loading saved documents: $e');
      // Don't emit error state, just log it
    }
  }
}
