import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entity/subject_entity.dart';
import '../domain/usecase/DocsUseCase.dart';
import '../domain/usecase/get_subjects_by_school_usecase.dart';
import '../domain/ui_model/doc_subject_lib_ui.dart';
import 'package:studydocs/core/error/error_mapper.dart';
import 'package:studydocs/core/exceptions/api_exception.dart';
import 'subject_library_event.dart';
import 'subject_library_state.dart';

class SubjectLibraryBloc
    extends Bloc<SubjectLibraryEvent, SubjectLibraryState> {
  final SearchDocumentsUseCase searchDocumentsUseCase;
  final LikeDocumentUseCase likeDocumentUseCase;
  final GetCommentsUseCase getCommentsUseCase;
  final DownloadDocumentUseCase downloadDocumentUseCase;
  final BookmarkDocumentUseCase bookmarkDocumentUseCase;
  final GetDocumentsByAcademicIdUseCase getDocumentsByAcademicIdUseCase;
  final GetSubjectsBySchoolUseCase getSubjectsBySchoolUseCase;

  SubjectLibraryBloc({
    required this.searchDocumentsUseCase,
    required this.likeDocumentUseCase,
    required this.getCommentsUseCase,
    required this.downloadDocumentUseCase,
    required this.bookmarkDocumentUseCase,
    required this.getDocumentsByAcademicIdUseCase,
    required this.getSubjectsBySchoolUseCase,
  }) : super(SubjectLibraryInitial()) {
    // ... (keep 1-6 listeners same or simplified if needed) ...
    // Note: I will keep existing listeners 1-6 as is for now, but update LoadBySchool.

    //
    // 1️ Load document theo keyword
    //
    on<SubjectLibraryLoadDocumentByKeyWord>((event, emit) async {
       // ... existing implementation ...
       emit(SubjectLibraryLoading());
       try {
        final docs = await searchDocumentsUseCase(event.keyword);
        emit(SubjectLibraryLoaded(
          subjectId: null, // Not loading by subject
          subjectName: event.keyword,
          uploaded_docs: const [],
          the_most_liked_docs: const [],
          documents: docs,
          schoolName: "Unknown School",
          num_docs: docs.length,
          subjects: const [],
        ));
       } catch (e) {
         emit(SubjectLibraryError(_getErrorMessage(e)));
       }
    });
    
    // ... (Other listeners: FindDocument, Like, Comment, Download, Bookmark) ...
    // Re-declaring them locally here to keep it compiling in this block replacement.
    
    //
    // 2️ Tìm document
    //
    on<FindDocument>((event, emit) async {
       emit(SubjectLibraryLoading());
       try {
        final docs = await searchDocumentsUseCase(event.keyword);
        emit(SubjectLibraryLoaded(
          subjectId: null, // Not loading by subject
          subjectName: event.keyword,
          uploaded_docs: const [],
          the_most_liked_docs: const [],
          documents: docs,
          schoolName: "Unknown School",
          num_docs: docs.length,
          subjects: const [],
        ));
       } catch (e) {
         emit(SubjectLibraryError(_getErrorMessage(e)));
       }
    });

    on<SubjectLibraryLikeDocument>((event, emit) async {
      try { await likeDocumentUseCase(event.documentId); } catch (e) { emit(SubjectLibraryError(_getErrorMessage(e))); }
    });
    on<SubjectLibraryOpenComments>((event, emit) async {
      try { await getCommentsUseCase(event.documentId); } catch (e) { emit(SubjectLibraryError(_getErrorMessage(e))); }
    });
    on<SubjectLibraryDownloadDocument>((event, emit) async {
      try { await downloadDocumentUseCase(event.documentId); } catch (e) { emit(SubjectLibraryError(_getErrorMessage(e))); }
    });
    on<SubjectLibraryBookmarkDocument>((event, emit) async {
      try { await bookmarkDocumentUseCase(event.documentId); } catch (e) { emit(SubjectLibraryError(_getErrorMessage(e))); }
    });


    //
    // 7️ Load subjects và documents theo school name
    //
    on<SubjectLibraryLoadBySchool>((event, emit) async {
      emit(SubjectLibraryLoading());

      try {
        // Load subjects và documents song song
        // Use Future.wait to optimize
        final results = await Future.wait<dynamic>([
           getSubjectsBySchoolUseCase(event.schoolId),
           getDocumentsByAcademicIdUseCase(universityId: event.schoolId),
        ]);

        final subjects = results[0] as List<SubjectEntity>; 
        final documents = results[1] as List<DocumentSubjectLibUI>;

        emit(
          SubjectLibraryLoaded(
            schoolId: event.schoolId,
            subjectId: null, // Loading by school, not specific subject
            schoolName: event.schoolName,
            subjectName: '',
            uploaded_docs: const [],
            the_most_liked_docs: const [],
            documents: documents,
            num_docs: documents.length,
            subjects: subjects,
          ),
        );
      } catch (e) {
        emit(SubjectLibraryError(_getErrorMessage(e)));
      }
    });

    on<SubjectLibraryLoadBySubject>((event, emit) async {
      emit(SubjectLibraryLoading());

      try {
        // Load documents theo subjectId (và universityId nếu có)
        final documents = await getDocumentsByAcademicIdUseCase(
          universityId: event.schoolId,
          subjectId: event.subjectId,
        );

        emit(
          SubjectLibraryLoaded(
            schoolId: event.schoolId,
            subjectId: event.subjectId, // Added
            schoolName: event.schoolName,
            subjectName: event.subjectName,
            uploaded_docs: const [],
            the_most_liked_docs: const [],
            documents: documents,
            num_docs: documents.length,
            subjects: const [],
          ),
        );
      } catch (e) {
        emit(SubjectLibraryError(_getErrorMessage(e)));
      }
    });
  }

  String _getErrorMessage(Object error) {
    if (error is ApiException) {
      return ErrorMapper.map(int.tryParse(error.code ?? ''));
    }
    return ErrorMapper.map(500);
  }

}
