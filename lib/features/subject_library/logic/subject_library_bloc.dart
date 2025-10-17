import "package:flutter_bloc/flutter_bloc.dart";

import "../data/subject_library_repository.dart";
import "subject_library_event.dart";
import "subject_library_state.dart";

/// ProfileBloc quản lý logic load/update dữ liệu
class SubjectLibraryBloc extends Bloc<SubjectLibraryEvent, SubjectLibraryState> {
  final SubjectLibraryRepository repository;

  SubjectLibraryBloc(this.repository) : super((SubjectLibraryInitial())) {
    // Xử lý sự kiện LoadDocument theo keyword
    on<SubjectLibraryLoadDocumentByKeyWord>((event, emit) async {
          emit(SubjectLibraryLoading());
          try {
            final uploaded_docs = await repository.getDocdemo();
            final most_liked_docs= await repository.getDocdemo();
            final documents= await repository.getDocdemo();
            emit(SubjectLibraryLoaded("Công nghệ phần mềm",uploaded_docs,most_liked_docs,documents));
          } catch (e) {
            emit(SubjectLibraryError(e.toString()));
          }
        });
  }
}
