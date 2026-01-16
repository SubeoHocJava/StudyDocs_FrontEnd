import 'package:flutter_bloc/flutter_bloc.dart';
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
  final GetSubjectsBySchoolUseCase getSubjectsBySchoolUseCase;

  SubjectLibraryBloc({
    required this.searchDocumentsUseCase,
    required this.likeDocumentUseCase,
    required this.getCommentsUseCase,
    required this.downloadDocumentUseCase,
    required this.bookmarkDocumentUseCase,
    required this.getSubjectsBySchoolUseCase,
  }) : super(SubjectLibraryInitial()) {
    //
    // 1️ Load document theo keyword
    //
    on<SubjectLibraryLoadDocumentByKeyWord>((event, emit) async {
      emit(SubjectLibraryLoading());

      try {
        final docs = await searchDocumentsUseCase(event.keyword);
        print(docs.length);
        emit(
          SubjectLibraryLoaded(
            event.keyword, // subject
            docs, // uploaded_docs
            docs, // the_most_liked_docs
            docs, // documents
            "Unknown School",
            0,
            docs.length,
            [], // subjects - empty khi load by keyword
          ),
        );
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });

    //
    // 2️ Tìm document (y như load, chỉ khác event loại khác)
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
            [], // subjects - empty khi find document
          ),
        );
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });

    //
    // 3️ Like document
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
    // 4️ Open comments
    //
    on<SubjectLibraryOpenComments>((event, emit) async {
      try {
        await getCommentsUseCase(event.documentId);
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });

    //
    // 5️ Download document
    //
    on<SubjectLibraryDownloadDocument>((event, emit) async {
      try {
        await downloadDocumentUseCase(event.documentId);
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });

    //
    // 6️ Bookmark document
    //
    on<SubjectLibraryBookmarkDocument>((event, emit) async {
      try {
        await bookmarkDocumentUseCase(event.documentId);
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });

    //
    // 7️ Load subjects và documents theo school name
    //
    on<SubjectLibraryLoadBySchool>((event, emit) async {
      emit(SubjectLibraryLoading());

      try {
        // Load subjects và documents song song
        // Pass schoolId instead of schoolName
        final subjects = await getSubjectsBySchoolUseCase(event.schoolId);
        // Tạm thời: search với empty query để lấy tất cả documents
        // Sau này khi có API: sẽ có method getDocumentsBySchool(schoolName)
        final allDocs = await searchDocumentsUseCase('');

        // Filter documents theo school name (nếu institution match)
        final schoolDocs =
            allDocs.where((doc) {
              final institution = doc.institution ?? '';
              return institution.toLowerCase().contains(
                    event.schoolName.toLowerCase(),
                  ) ||
                  event.schoolName.toLowerCase().contains(
                    institution.toLowerCase(),
                  );
            }).toList();

        // Nếu không có documents match, dùng tất cả (cho mock data)
        final docs = schoolDocs.isNotEmpty ? schoolDocs : allDocs;

        // Sort documents: most liked first
        final sortedDocs = List.from(docs);
        sortedDocs.sort(
          (a, b) => (b.likesCount ?? 0).compareTo(a.likesCount ?? 0),
        );

        // Uploaded docs: sort by createdAt (newest first)
        final uploadedDocs = List.from(docs);
        uploadedDocs.sort((a, b) {
          final aDate = a.createdAt ?? '';
          final bDate = b.createdAt ?? '';
          return bDate.compareTo(aDate);
        });

        emit(
          SubjectLibraryLoaded(
            '', // subject - không dùng khi load by school
            List<DocumentSubjectLibUI>.from(
              uploadedDocs.take(3),
            ), // uploaded_docs - lấy 3 mới nhất
            List<DocumentSubjectLibUI>.from(
              sortedDocs.take(3),
            ), // the_most_liked_docs - lấy 3 nhiều like nhất
            docs, // documents - tất cả
            event.schoolName, // school
            0, // num_friends
            docs.length, // num_docs
            subjects, // subjects - danh sách môn học
          ),
        );
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });
  }
}
