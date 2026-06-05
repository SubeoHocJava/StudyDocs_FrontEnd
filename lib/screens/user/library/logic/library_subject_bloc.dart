import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/screens/user/library/domain/usecase/get_library_subject_page_usecase.dart';
import 'package:studydocs/screens/user/library/logic/library_subject_event.dart';
import 'package:studydocs/screens/user/library/logic/library_subject_state.dart';

class LibrarySubjectBloc
    extends Bloc<LibrarySubjectEvent, LibrarySubjectState> {
  final GetLibrarySubjectPageUseCase _getLibrarySubjectPageUseCase;

  LibrarySubjectBloc({
    required GetLibrarySubjectPageUseCase getLibrarySubjectPageUseCase,
  })  : _getLibrarySubjectPageUseCase = getLibrarySubjectPageUseCase,
        super(const LibrarySubjectInitial()) {
    on<LibrarySubjectRequested>(_onRequested);
  }

  Future<void> _onRequested(
    LibrarySubjectRequested event,
    Emitter<LibrarySubjectState> emit,
  ) async {
    emit(const LibrarySubjectLoading());
    try {
      final data = await _getLibrarySubjectPageUseCase(event.subjectId);
      emit(LibrarySubjectLoaded(data));
    } catch (error) {
      emit(LibrarySubjectFailure(error.toString()));
    }
  }
}
