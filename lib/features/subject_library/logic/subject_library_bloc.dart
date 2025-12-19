import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/subject_library/domain/entity/DocumentEntity.dart';
import '../../../features/library/data/model/Document.dart';
import '../domain/usecase/DocsUseCase.dart';
import 'subject_library_event.dart';
import 'subject_library_state.dart';



class SubjectLibraryBloc extends Bloc<SubjectLibraryEvent, SubjectLibraryState> {

  final SearchDocumentsUseCase searchDocumentsUseCase;
  final LikeDocumentUseCase likeDocumentUseCase;
  final GetCommentsUseCase getCommentsUseCase;
  final DownloadDocumentUseCase downloadDocumentUseCase;
  final BookmarkDocumentUseCase bookmarkDocumentUseCase;

  SubjectLibraryBloc({
    required this.searchDocumentsUseCase,
    required this.likeDocumentUseCase,
    required this.getCommentsUseCase,
    required this.downloadDocumentUseCase,
    required this.bookmarkDocumentUseCase,
  }) : super(SubjectLibraryInitial()) {
    //
    // 1️⃣ Load document theo keyword
    //
    on<SubjectLibraryLoadDocumentByKeyWord>((event, emit) async {
      emit(SubjectLibraryLoading());

      try {
        final docs = await searchDocumentsUseCase(event.keyword);

        emit(
          SubjectLibraryLoaded(
            event.keyword,   // subject
            docs,            // uploaded_docs
            docs,            // the_most_liked_docs
            docs,            // documents
            "Unknown School",
            0,
            docs.length,
          ),
        );
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });



    //
    // 2️⃣ Tìm document (y như load, chỉ khác event loại khác)
    //
    on<FindDocument>((event, emit) async {
      emit(SubjectLibraryLoading());

      try {
        final docs = await searchDocumentsUseCase(event.keyword);

        emit(
          SubjectLibraryLoaded(
            event.keyword,
            docs,
            docs,
            docs,
            "Unknown School",
            0,
            docs.length,
          ),
        );
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });



    //
    // 3️⃣ Like document
    //
    on<SubjectLibraryLikeDocument>((event, emit) async {
      try {
        await likeDocumentUseCase(event.documentId);
        // Không emit loaded mới để tránh reload UI toàn bộ
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });



    //
    // 4️⃣ Open comments
    //
    on<SubjectLibraryOpenComments>((event, emit) async {
      try {
        await getCommentsUseCase(event.documentId);
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });



    //
    // 5️⃣ Download document
    //
    on<SubjectLibraryDownloadDocument>((event, emit) async {
      try {
        await downloadDocumentUseCase(event.documentId);
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });



    //
    // 6️⃣ Bookmark document
    //
    on<SubjectLibraryBookmarkDocument>((event, emit) async {
      try {
        await bookmarkDocumentUseCase(event.documentId);
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });
  }
}
