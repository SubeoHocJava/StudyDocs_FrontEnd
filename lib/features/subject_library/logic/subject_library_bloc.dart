import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_event.dart';
import 'package:studydocs/features/subject_library/logic/subject_library_state.dart';

import '../data/subject_library_repository.dart';

class SubjectLibraryBloc extends Bloc<SubjectLibraryEvent, SubjectLibraryState> {
  final SubjectLibraryRepository repository;

  SubjectLibraryBloc(this.repository) : super(SubjectLibraryInitial()) {
    on<SubjectLibraryLoadDocumentByKeyWord>((event, emit) async {
      emit(SubjectLibraryLoading());
      try {
        final uploaded_docs = await repository.getDocdemo();
        final most_liked_docs = await repository.getDocdemo();
        final documents = await repository.getDocdemo();

        // Giá trị demo — bạn thay bằng dữ liệu thật nếu cần
        final school = "Đại học nông lâm";
        final subject = "Công nghệ phần mềm";
        final num_friends = 10;
        final num_docs = documents.length;

        emit(
          SubjectLibraryLoaded(
            subject,
            uploaded_docs,
            most_liked_docs,
            documents,
            school,
            num_friends,
            num_docs,
          ),
        );
      } catch (e) {
        emit(SubjectLibraryError(e.toString()));
      }
    });

  }
}
