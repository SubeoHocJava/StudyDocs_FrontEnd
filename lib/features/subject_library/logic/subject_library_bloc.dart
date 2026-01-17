import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entity/subject_entity.dart';
import '../domain/usecase/DocsUseCase.dart';
import '../domain/usecase/get_subjects_by_school_usecase.dart';
import '../domain/ui_model/doc_subject_lib_ui.dart';
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
          event.keyword, [], [], docs, "Unknown School", 0, docs.length, [],
        ));
       } catch (e) {
         emit(SubjectLibraryError(e.toString()));
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
          event.keyword, [], [], docs, "Unknown School", 0, docs.length, [],
        ));
       } catch (e) {
         emit(SubjectLibraryError(e.toString()));
       }
    });

    on<SubjectLibraryLikeDocument>((event, emit) async {
      try { await likeDocumentUseCase(event.documentId); } catch (e) { emit(SubjectLibraryError(e.toString())); }
    });
    on<SubjectLibraryOpenComments>((event, emit) async {
      try { await getCommentsUseCase(event.documentId); } catch (e) { emit(SubjectLibraryError(e.toString())); }
    });
    on<SubjectLibraryDownloadDocument>((event, emit) async {
      try { await downloadDocumentUseCase(event.documentId); } catch (e) { emit(SubjectLibraryError(e.toString())); }
    });
    on<SubjectLibraryBookmarkDocument>((event, emit) async {
      try { await bookmarkDocumentUseCase(event.documentId); } catch (e) { emit(SubjectLibraryError(e.toString())); }
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
            '', // subject
            [], // uploaded_docs (removed)
            [], // the_most_liked_docs (removed)
            documents, // documents (The main list)
            event.schoolName, // school
            0, // num_friends
            documents.length, // num_docs
            subjects, // subjects
          ),
        );
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });
  }

}
